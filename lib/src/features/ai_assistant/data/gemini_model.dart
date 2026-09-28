import 'package:firebase_ai/firebase_ai.dart';

const _modelName = 'gemini-3.8-flash';

/// The Gemini model used by the assistant, set to always reply in JSON.
GenerativeModel createGeminiModel() {
  return FirebaseAI.googleAI().generativeModel(
    model: _modelName,
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );
}
