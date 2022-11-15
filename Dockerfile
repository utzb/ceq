FROM python:3

COPY requirements.txt ./

# put this into the python file to speed up builds
# import os
# os.system('pip install requests')
RUN pip install --no-cache-dir -r requirements.txt

COPY src /src

WORKDIR /src

CMD [ "python", "./main.py" ]