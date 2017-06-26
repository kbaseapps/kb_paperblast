FROM kbase/kbase:sdkbase.latest
MAINTAINER John-Marc Chandonia
# -----------------------------------------
# In this section, you can install any system dependencies required
# to run your App.  For instance, you could place an apt-get update or
# install line here, a git checkout to download code, or run any other
# installation scripts.

# RUN apt-get update

RUN apt-get update
RUN apt-get install sqlite3 libswiss-perl libxml-parser-perl --yes

WORKDIR /kb/module
RUN mkdir -p /kb/module/dependencies/

WORKDIR /kb/module/dependencies/
RUN git clone https://github.com/morgannprice/PaperBLAST
RUN curl -L ftp://ftp.ncbi.nlm.nih.gov/blast/executables/legacy/2.2.26/blast-2.2.26-x64-linux.tar.gz -o blast-2.2.26-x64-linux.tar.gz && \
    tar xzvf blast-2.2.26-x64-linux.tar.gz && \
    mv blast-2.2.26/bin/* PaperBLAST/bin
RUN rm -rf blast-2.2.26 blast-2.2.26-x64-linux.tar.gz

WORKDIR /kb/module/dependencies/
RUN curl -L https://ndownloader.figshare.com/files/8029148 -o PaperBLAST_Apr2017.tar.gz && \
    tar xzvf PaperBLAST_Apr2017.tar.gz

# download an inifile reader
RUN cpanm -i Config::IniFiles

# -----------------------------------------

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod -R a+rw /kb/module

WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
