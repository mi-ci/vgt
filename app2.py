from flask import Flask, request, send_file
import numpy as np
import cv2
import io
import tensorflow as tf
from PIL import Image, ImageDraw, ImageFont

app = Flask(__name__)
model = tf.keras.models.load_model('best.h5')  # Replace with your model's path

def preprocess_image(image):
    # Resize and normalize the image as required by your model
    image = cv2.resize(image, (224, 224))  # Adjust the size according to your model's input size
    image = image.astype('float32') / 255.0
    image = np.expand_dims(image, axis=0)
    return image

def draw_boxes(image, predictions):
    draw = ImageDraw.Draw(image)
    font = ImageFont.load_default()

    for pred in predictions:
        label, confidence, box = pred['label'], pred['confidence'], pred['box']
        left, top, right, bottom = box
        draw.rectangle([left, top, right, bottom], outline="red", width=2)
        draw.text((left, top), f"{label} {confidence:.2f}", fill="red", font=font)

    return image

def process_predictions(predictions):
    # Example function to convert model output to a list of dictionaries
    # Adjust this according to your model's specific output
    processed_predictions = []
    for prediction in predictions:
        processed_predictions.append({
            'label': 'object',  # Example label
            'confidence': prediction[1],  # Example confidence
            'box': [int(coord) for coord in prediction[2:]]  # Example bounding box
        })
    return processed_predictions

@app.route('/predict', methods=['POST'])
def upload_file():
    file = request.files['frame']
    img_bytes = file.read()
    nparr = np.frombuffer(img_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    # Preprocess the image
    processed_img = preprocess_image(img)

    # Make predictions
    predictions = model.predict(processed_img)
    # print(predictions)
    max = np.argmax(predictions)[0]


    # Process the predictions
    processed_predictions = process_predictions(predictions)

    # Convert image to PIL format for drawing
    image_pil = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))

    # Draw boxes and labels
    result_image = draw_boxes(image_pil, processed_predictions)

    # Convert PIL image back to OpenCV format
    result_image = cv2.cvtColor(np.array(result_image), cv2.COLOR_RGB2BGR)

    # Encode image to send back to client
    _, img_encoded = cv2.imencode('.png', result_image)
    return send_file(io.BytesIO(img_encoded), mimetype='image/png')

if __name__ == '__main__':
    app.run(debug=True)
