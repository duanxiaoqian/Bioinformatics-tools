## database confirmation

# load package

# set work directory
setwd("I:/段光前-工作资料/开发任务/20200312-数据库开发/wiff测试")
path <- getwd()
infiletype <- ".wiff" # .raw .wiff
outfiletype <- "mzXML"
outDir <- paste0(path, "/wkdir")
software <- "C:/Users/Pioneer/AppData/Local/Apps/ProteoWizard 3.0.19330.b48e33310 64-bit"
databasepath <- "I:/段光前-工作资料/开发任务/20200312-数据库开发/ms2_identification_demo_data1"

suppressMessages(library(MSIdentify))
system.time(MSQualitativeAnalysis(rawFiles = MSConvertor::getgoalfile(path, infiletype),
                      outDir = outDir, outfiletype = "mzXML",
                      nCores = 3,
                      software = software,
                      databasepath = databasepath,
                      database= c(
                        "msDatabase_rplc0.0.2",
                        # "massbankDatabase0.0.1",
                        "orbitrapDatabase0.0.1",
                        # "monaDatabase0.0.1",
                        "hmdbDatabase0.0.1"
                      ),
                      polarity = "neg",
                      step=1:4)
              )[3]/60

