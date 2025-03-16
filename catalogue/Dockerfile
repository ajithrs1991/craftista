FROM python:3.12.9-slim-bookworm
COPY catalogue/ /catalogue
WORKDIR /catalogue
RUN pip install -r requirements.txt
EXPOSE 5000
ENTRYPOINT ["gunicorn", "app:app", "--bind", "0.0.0.0:5000"]
