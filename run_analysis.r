required_packages <- c("knitr","markdown")
install_required <- setdiff(required_packages,rownames(installed.packages()))
if(length(install_required)!=0) {install.packages(install_required)}

##This file is primarily used to execute the rmd file to generate the html format
##Most of the actual coding is done in the rmd file along with html file
require(knitr)
require(markdown)


knit("run_analysis.Rmd", encoding="ISO8859-1")
markdownToHTML("run_analysis.md", "run_analysis.html")
