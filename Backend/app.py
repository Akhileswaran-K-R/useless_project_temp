from flask import Flask, request, jsonify
import os
import google.generativeai as genai
from dotenv import load_dotenv

app = Flask(__name__)
load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
  raise ValueError("GEMINI_API_KEY not found in .env file.")
genai.configure(api_key=api_key)

@app.route('/')
def index():
  return "🕒 Clock Time Detection API is running. Use POST /detect-time to send an image."

@app.route('/detect-time', methods=['POST'])
def detect_time():
  try:
    file = request.files.get("image")
    if not file:
        return jsonify({"error": "No image uploaded"}), 400

    image_bytes = file.read()

    model = genai.GenerativeModel('models/gemini-2.5-pro')
    response = model.generate_content([
      "From this clock image, output the detected time only. No extra text, comments, or explanation.",
      {"mime_type": "image/jpeg", "data": image_bytes}
    ])

    return jsonify({"time": response.text.strip()})

  except Exception as e:
    return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
  app.run(debug=True)