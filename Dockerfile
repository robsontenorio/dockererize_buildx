# Use an official Python runtime as a parent image
FROM python:3 

ENV FLASK_ENV=production

# Set the working directory in the container
WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000

CMD flask run --host=0.0.0.0
