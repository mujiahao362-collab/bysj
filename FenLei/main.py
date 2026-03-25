from flask import Flask, render_template, request, session
import os
from werkzeug.utils import secure_filename
import GetIP
# import inference
# import cv2
# import time


# 指定要删除的文件路径
file_path = "static/uploads/temp.jpg"

# 检查文件是否存在
# if os.path.exists(file_path):
#     # 删除文件
#     os.remove(file_path)
#     print(f"文件 {file_path} 已成功删除。")
# else:
#     print(f"文件 {file_path} 不存在。")


UPLOAD_FOLDER = os.path.join('static', 'uploads')
ALLOWED_EXTENSIONS = {'bmp', 'jpg', 'jpeg'}

# The default folder name for static files should be "static"
app = Flask(__name__, template_folder='templates', static_folder='static')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.secret_key = 'You can write anything, is just a test'


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/', methods=("POST", "GET"))
def upload_file():
    if request.method == 'POST':
        uploaded_img = request.files['uploaded-file']
        img_filename = secure_filename(uploaded_img.filename)  # 与上传文件同名
        img_filename = 'temp.jpg'  # 指定文件名
        # Upload file to database (defined uploaded folder in static path)
        uploaded_img.save(os.path.join(
            app.config['UPLOAD_FOLDER'], img_filename))
        # Storing uploaded file path in flask session
        session['uploaded_img_file_path'] = os.path.join(
            app.config['UPLOAD_FOLDER'], img_filename)

        return render_template('uploaded_image.html')


# message = os.popen('python inference.py').read()
# print(message)


@app.route('/show_image')
def display_image():
    message = os.popen('python inference.py').read()
    # Retrieving uploaded file
    # message = inference.message
    img_file_path = session.get('uploaded_img_file_path', None)
    # Display image in Flask application web page
    return render_template('show_image.html', user_image=img_file_path, user_message=message)


if __name__ == '__main__':
    # app.run(debug=True, port=8000)
    ip_address = GetIP.ip_address
    print(ip_address)
    # print(message)
    app.run(debug=True, host=ip_address, port=8000)  # 替换 X 为你的 IP 地址最后一段

    # # message = ''
    # image = cv2.imread('images/banana.jpg')
    # t0 = time.time()
    # inference(image)
    # # message = inference.message
    # print(time.time()-t0)
    # print(inference.DataSetInfo['group_count']['train'])
    # print(inference.message)
