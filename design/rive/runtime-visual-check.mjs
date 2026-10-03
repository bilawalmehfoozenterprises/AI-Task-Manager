import fs from 'node:fs';
import {createRequire} from 'node:module';

const packageRoot = '/tmp/rive-validation/node_modules';
const require = createRequire(`${packageRoot}/package.json`);
const {createCanvas, Path2D, ImageData, DOMMatrix, loadImage} = require('@napi-rs/canvas');

globalThis.Path2D = Path2D;
globalThis.ImageData = ImageData;
globalThis.DOMMatrix = DOMMatrix;
globalThis.document = {
  createElement: () => {
    const canvas = createCanvas(400, 240);
    const getContext = canvas.getContext.bind(canvas);
    canvas.getContext = type => type === '2d' ? getContext('2d') : null;
    return canvas;
  },
};
globalThis.window = {
  devicePixelRatio: 1,
  requestAnimationFrame: () => 0,
  cancelAnimationFrame: () => {},
};

const {default: Rive} = await import(`${packageRoot}/@rive-app/canvas-advanced/canvas_advanced.mjs`);
const rive = await Rive({
  wasmBinary: fs.readFileSync(`${packageRoot}/@rive-app/canvas-advanced/rive.wasm`),
});
const file = await rive.load(new Uint8Array(fs.readFileSync(process.argv[2])));
const outputDirectory = process.argv[3];
const artboards = ['Task Buddy Refresh', 'Task Tornado Refresh'];
const cases = [
  {label: 'Pull 0%', pull: 0, phase: 0, frames: 1},
  {label: 'Pull 25%', pull: .25, phase: 0, frames: 1},
  {label: 'Pull 50%', pull: .5, phase: 0, frames: 1},
  {label: 'Pull 75%', pull: .75, phase: 0, frames: 1},
  {label: 'Pull 100%', pull: 1, phase: 0, frames: 1},
  {label: 'Refreshing', pull: 1, phase: 1, frames: 45},
  {label: 'Complete', pull: 1, phase: 2, frames: 48},
  {label: 'Failed', pull: 1, phase: 3, frames: 24},
  {label: 'Reduced complete', pull: 1, phase: 4, frames: 1},
];

function advance(state, frames) {
  for (let index = 0; index < frames; index += 1) {
    state.machine.advance(1 / 60);
    state.artboard.advance(1 / 60);
  }
}

function createState(name) {
  const artboard = file.artboardByName(name);
  const viewModel = file.viewModelByName('RefreshControls').instanceByName('Default');
  const machine = new rive.StateMachineInstance(artboard.stateMachineByName('Refresh'), artboard);
  machine.bindViewModelInstance(viewModel);
  artboard.bindViewModelInstance(viewModel);
  return {artboard, viewModel, machine};
}

function drawCase(name, testCase) {
  const state = createState(name);
  state.viewModel.number('pullProgress').value = testCase.pull;
  state.viewModel.number('phase').value = testCase.phase;
  if (testCase.theme) {
    state.viewModel.color('accent').argb(255, 255, 112, 122);
    state.viewModel.color('success').argb(255, 182, 241, 145);
    state.viewModel.color('surfaceContrast').argb(255, 255, 238, 208);
  }
  advance(state, testCase.frames);

  const canvas = createCanvas(400, 240);
  const renderer = rive.makeRenderer(canvas);
  renderer.clear();
  state.artboard.draw(renderer);
  renderer.flush();
  rive.resolveAnimationFrame();

  const result = canvas.toBuffer('image/png');
  const completed = state.viewModel.number('completionProgress').value;
  state.machine.delete();
  state.artboard.delete();
  state.viewModel.delete();
  return {result, completed};
}

function verifyReversal(name) {
  const state = createState(name);
  const reveal = state.artboard.node('Pull Reveal');
  const values = [];
  for (const progress of [0, .25, .5, .75, 1, .75, .5, .25, 0]) {
    state.viewModel.number('pullProgress').value = progress;
    advance(state, 1);
    values.push(Number(reveal.scaleX.toFixed(2)));
  }
  state.machine.delete();
  state.artboard.delete();
  state.viewModel.delete();
  return values;
}

for (const artboard of artboards) {
  const sheet = createCanvas(800, 720);
  const context = sheet.getContext('2d');
  context.fillStyle = '#15151e';
  context.fillRect(0, 0, 800, 720);
  context.font = '16px sans-serif';
  context.fillStyle = '#eeedff';
  context.fillText(artboard, 20, 28);

  for (const [index, testCase] of cases.entries()) {
    const {result, completed} = drawCase(artboard, testCase);
    const image = await loadImage(result);
    const x = (index % 3) * 266;
    const y = 45 + Math.floor(index / 3) * 220;
    context.drawImage(image, x, y, 266, 160);
    context.fillStyle = '#eeedff';
    context.font = '14px sans-serif';
    context.fillText(testCase.label, x + 12, y + 184);
    context.fillStyle = '#b3b3dd';
    context.fillText(`completion ${completed}`, x + 12, y + 204);
  }
  const fileName = artboard === 'Task Buddy Refresh' ? 'buddy-validation.png' : 'tornado-validation.png';
  fs.writeFileSync(`${outputDirectory}/${fileName}`, sheet.toBuffer('image/png'));
  const theme = drawCase(artboard, {pull: 1, phase: 1, frames: 30, theme: true});
  const themeName = artboard === 'Task Buddy Refresh' ? 'buddy-theme-validation.png' : 'tornado-theme-validation.png';
  fs.writeFileSync(`${outputDirectory}/${themeName}`, theme.result);
  console.log(`${fileName}: written; ${themeName}: written; reversal ${verifyReversal(artboard).join(', ')}`);
}

file.delete();
