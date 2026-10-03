import fs from 'node:fs';
import {createCanvas,Path2D,ImageData,DOMMatrix} from '@napi-rs/canvas';
globalThis.Path2D=Path2D;globalThis.ImageData=ImageData;globalThis.DOMMatrix=DOMMatrix;
globalThis.document={createElement:()=>{const c=createCanvas(400,240);const get=c.getContext.bind(c);c.getContext=(type,opts)=>type==='2d'?get('2d'):null;return c;}};
globalThis.window={devicePixelRatio:1,requestAnimationFrame:()=>0,cancelAnimationFrame:()=>{}};
const {default:Rive}=await import('@rive-app/canvas-advanced');
const rive=await Rive({wasmBinary:fs.readFileSync('/tmp/rive-validation/node_modules/@rive-app/canvas-advanced/rive.wasm')});
const file=await rive.load(new Uint8Array(fs.readFileSync(process.argv[2]||'/tmp/rive-validation/both.riv')));
console.log('artboards',file.artboardCount());
for(let i=0;i<file.artboardCount();i++){
 const a=file.artboardByIndex(i); console.log('artboard',a.name); if(!['Task Buddy Refresh','Task Tornado Refresh'].includes(a.name)){a.delete();continue;}
 const v=file.viewModelByName('RefreshControls').instanceByName('Default');
 const sm=new rive.StateMachineInstance(a.stateMachineByName('Refresh'),a); sm.bindViewModelInstance(v); a.bindViewModelInstance(v);
 const phase=v.number('phase'),pull=v.number('pullProgress'),completion=v.number('completionProgress');
 function step(n){let states=[];for(let k=0;k<n;k++){sm.advance(1/60);a.advance(1/60);for(let j=0;j<sm.stateChangedCount();j++)states.push(sm.stateChangedNameByIndex(j));}return states;}
 pull.value=1;
 for(const p of [0,1,2,0,1,3,0,4,0]){phase.value=p;let states=step(90);console.log({phase:p,states,done:completion.value});}
 const c=createCanvas(400,240);const renderer=rive.makeRenderer(c);
 phase.value=1;step(15);renderer.clear();a.draw(renderer);renderer.flush();rive.resolveAnimationFrame();fs.writeFileSync('/tmp/rive-validation/'+i+'.png',c.toBuffer('image/png'));
 sm.delete();a.delete();v.delete();
}
file.delete();
