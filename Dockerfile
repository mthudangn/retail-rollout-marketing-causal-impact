FROM rocker/r-ver:4.4.1
WORKDIR /project
COPY requirements.R /project/requirements.R
RUN Rscript requirements.R
COPY . /project
CMD ["Rscript", "run_pipeline.R"]
