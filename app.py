from flask import Flask, request, jsonify
import numpy as np
import cv2
import io
from ultralytics import YOLO
from ultralytics.utils.plotting import Annotator
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import img_to_array
import base64
app = Flask(__name__)
model = YOLO('best1.pt')  # YOLOv8 모델 로드
# 2. vegetable_classifier_model.h5 모델 로드
classifier_model = load_model('best.h5')

@app.route('/predict', methods=['POST'])
def upload_file():
    file = request.files['frame']
    img_bytes = file.read()
    nparr = np.frombuffer(img_bytes, np.uint8)
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    em_li=[]

    # 1. YOLOv8 모델 로드 및 이미지 예측
    results = model(image)  # 이미지 예측


    # 바운딩 박스 좌표 추출 및 이미지에 그리기
    bounding_boxes = []
    for result in results[0].boxes:
        # 좌표와 신뢰도 추출
        xmin, ymin, xmax, ymax = result.xyxy[0]
        confidence = result.conf[0]
        if confidence > 0.2:  # 신뢰도 임계값 설정
            bounding_boxes.append((int(xmin), int(ymin), int(xmax), int(ymax)))
            # 바운딩 박스 그리기
            cv2.rectangle(image, (int(xmin), int(ymin)), (int(xmax), int(ymax)), (0, 255, 0), 2)

    # 바운딩 박스 좌표 출력
    print("Bounding Box Coordinates:")
    for box in bounding_boxes:
        print(box)

    # 바운딩 박스가 그려진 이미지 저장
    output_image_path = 'output_with_bboxes.jpg'
    cv2.imwrite(output_image_path, image)
    print(f'Saved image with bounding boxes: {output_image_path}')

    ouim = cv2.imread(output_image_path)
    _, buffer = cv2.imencode('.png', ouim)
    encoded_image = base64.b64encode(buffer).decode('utf-8')

    # 클래스 이름 정의 (예: 채소 종류에 따라 변경)
    class_names = ['Bean', 'Bitter_Gourd', 'Bottle_Gourd', 'Brinjal', 'Broccoli',
            'Cabbage','Capsicum','Carrot','Cauliflower', 'Cucumber','Papaya','Potato','Pumpkin'
            ,'Radish','Tomato']

    # 3. 바운딩 박스 영역 잘라내기 및 4. 이미지 분류
    for i, (xmin, ymin, xmax, ymax) in enumerate(bounding_boxes):
        cropped_image = image[ymin:ymax, xmin:xmax]
        # 이미지 크기 조정 (예: 150x150)
        resized_image = cv2.resize(cropped_image, (224, 224))  # 모델의 입력 크기에 맞게 조정
        # 전처리 (예: 정규화)
        normalized_image = resized_image / 255.0
        # 차원 추가 (모델 입력 형식에 맞게 조정)
        input_image = np.expand_dims(normalized_image, axis=0)

        # 모델 예측
        prediction = classifier_model.predict(input_image)
        predicted_class = np.argmax(prediction, axis=1)
        class_name = class_names[predicted_class[0]]

        # 예측 결과 출력
        print(f'Bounding Box {i}: {class_name} (Confidence: {np.max(prediction)})')
        if em_li.count(class_name)>0:
            pass
        else :
            em_li.append(class_name)

        # 잘라낸 이미지를 파일로 저장
        cropped_image_path = f'cropped_image_{i}_{class_name}.jpg'
        cv2.imwrite(cropped_image_path, cropped_image)
        print(f'Saved cropped image: {cropped_image_path}')



    # JSON response
    response = {
        'image': encoded_image,
        'classifications': em_li
    }
    return jsonify(response)


if __name__ == '__main__':
    app.run(debug=True)
