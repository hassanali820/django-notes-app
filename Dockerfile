# ------- Base image -------
FROM python:3.9-slim

# Prevent .pyc files and enable logging
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory inside container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy project code
COPY . /app/

# Expose Django port
EXPOSE 8000

# Run migrations (optional for compose)
CMD ["gunicorn", "notesapp.wsgi:application", "--bind", "0.0.0.0:8000"]
