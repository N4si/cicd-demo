FROM python:3.8
WORKDIR /app
COPY . /app
RUN pip install flask
RUN pip install --upgrade werkzeug
EXPOSE 8080
ENTRYPOINT ["python"]
CMD ["app.py"]
