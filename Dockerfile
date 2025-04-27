# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.9-slim

EXPOSE 5001

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt update && apt install -y unzip

COPY . /app

RUN unzip -P 'pymazda-backup.zip' pymazda-enc.zip && \
  mv pymazda /usr/local/lib/python3.9/site-packages/ && \
  mv pymazda-0.3.11.dist-info /usr/local/lib/python3.9/site-packages/ && \
  rm -rf pymazda-enc.zip

RUN python -m pip install -r requirements.txt

RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:5001", "app:app"]
