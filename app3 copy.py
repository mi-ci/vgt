from flask import Flask, request, send_file
import numpy as np
import cv2
import io
from ultralytics import YOLO
from ultralytics.utils.plotting import Annotator
app = Flask(__name__)
model = YOLO('ep100.pt')

@app.route('/predict', methods=['POST'])
def upload_file():
    file = request.files['frame']
    img_bytes = file.read()
    nparr = np.frombuffer(img_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    results = model(img)
    if len(list(results[0].boxes.cls.detach().numpy()))>0:
        annotator = Annotator(img)
        boxes = results[0].boxes
        for box in boxes:
            b = box.xyxy[0]
            c = box.cls
            annotator.box_label(b, model.names[int(c)])

        processed_img = annotator.result()
    em_li = []
    for i in list(results[0].boxes.cls.detach().numpy()) :
        em_li.append(i)
        

    # Encode image to send back to client
    _, img_encoded = cv2.imencode('.png', processed_img)
    return send_file(io.BytesIO(img_encoded), mimetype='image/png')

if __name__ == '__main__':
    app.run(debug=True)
