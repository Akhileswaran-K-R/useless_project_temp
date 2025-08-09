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

@app.route('/detect-time', methods=['POST'])
def detect_time():
    try:
        file = request.files.get("image")
        if not file:
            return jsonify({"error": "No image uploaded"}), 400

        image_bytes = file.read()

        model = genai.GenerativeModel('models/gemini-1.5-flash')
        response = model.generate_content([
            "What time is shown on this clock?",
            {"mime_type": "image/jpeg", "data": image_bytes}
        ])

        return jsonify({"time": response.text.strip()})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)


# import cv2
# import numpy as np
# import math

# def detect_time_from_clock(image_path):
#     img = cv2.imread(image_path)
#     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
#     gray_blur = cv2.GaussianBlur(gray, (5,5), 0)

#     circles = cv2.HoughCircles(gray_blur, cv2.HOUGH_GRADIENT, 1, 200,param1=50, param2=30, minRadius=100, maxRadius=300)
#     if circles is None:
#         return "No clock detected"
    
#     circles = np.uint16(np.around(circles))
#     x_center, y_center, radius = circles[0][0]

#     mask = np.zeros_like(gray)
#     cv2.circle(mask, (x_center, y_center), radius, 255, -1)
#     clock_face = cv2.bitwise_and(gray, gray, mask=mask)

#     edges = cv2.Canny(clock_face, 50, 150)
#     lines = cv2.HoughLinesP(edges, 1, np.pi/180, 100, minLineLength=50, maxLineGap=10)

#     hand_angles = []
#     if lines is not None:
#         for line in lines:
#             x1, y1, x2, y2 = line[0]
#             dist1 = math.hypot(x1 - x_center, y1 - y_center)
#             dist2 = math.hypot(x2 - x_center, y2 - y_center)
#             # Keep lines that start near center
#             if dist1 < radius*0.2 or dist2 < radius*0.2:
#                 dx, dy = x2 - x1, y1 - y2  # note y-axis inversion
#                 angle = math.degrees(math.atan2(dy, dx)) % 360
#                 length = max(dist1, dist2)
#                 hand_angles.append((length, angle))

#     if len(hand_angles) < 1:
#         print(hand_angles)
#         return "Not enough hands detected"

#     hand_angles.sort(reverse=True)
#     minute_angle = hand_angles[0][1]
#     hour_angle = hand_angles[1][1]

#     minute = int(round(minute_angle / 6) % 60)
#     hour = int((hour_angle / 30) % 12)
#     hour = (hour + minute/60) % 12

#     return f"Detected time: {int(hour)}:{minute:02d}"

# print(detect_time_from_clock("clock4.png"))
