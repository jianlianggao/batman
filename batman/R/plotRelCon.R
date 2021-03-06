plotRelCon<-function(BM, metaName, plotHist = FALSE, breaks, saveFig = TRUE, 
                     saveFigDir = BM$outputDir, prefixFig, rerun = FALSE, overwriteFig = FALSE)
{
  ## written by Dr. Jie Hao, Imperial College London
  ## histogram or boxplot of relative concentration posteriors for listed metabolites with 95% credible interval
  if (missing(BM))
    return(cat("Please input batman data list.\n"))
  
  warnDef<-options("warn")$warn
  warnRead<-options(warn = -1)
  ptype = "pdf"
  n <- 4
  ns<-5
  
  m<-row.names(BM$beta)
  if (!missing(metaName))
  {
    mind<-which(!is.na(match(tolower(m),tolower(metaName)))) 
    if (length(mind)==0) 
      return(cat("No matching metabolite found...\n"))   
  } else {
    metaName <-NULL
    mind<-1:length(m)
  }
  
  ## plot batman results
  if (!is.null(BM$betaSam) && !rerun) 
  {
    r<-row.names(BM$betaSam)
    #f<-nrow(BM$betaSam)
    f<-length(mind)
    fc<-ncol(BM$betaSam)
    sno<-BM$specRange
    ind<-fc/length(sno)
    outpdf1<-NULL
    for (i in 1:length(sno)) 
    {
      if (plotHist)
      {
        for (j in 1:f)
        {
          ## set subplot
          if ((j%%n)==1)
          {
            if ((f-j)>=1) 
            {
              if (!missing(prefixFig))
                outpdf1 <- paste(saveFigDir, "/", prefixFig,"_spec_",sno[i],"RelCon_", mind[j], "to",mind[min(j+n-1,length(mind))],".",ptype, sep="")
              else
                outpdf1 <- paste(saveFigDir,"/spec_",sno[i],"RelCon_",mind[j], "to",mind[min(j+n-1,length(mind))],".",ptype, sep="")  
              #x11(15,7)
              # replace by pdf device
              pdf(outpdf1, width = 20, height = 15, pointsize = 20)
              
              
              par(mfrow=c(2, 2),oma = c(0, 0, 3, 0))	
            } else {
              if (!missing(prefixFig))
                outpdf1 <- paste(saveFigDir, "/", prefixFig, "_spec_",sno[i],"RelCon_", mind[j], ".",ptype, sep="")
              else
                outpdf1 <- paste(saveFigDir,"/spec_",sno[i],"RelCon_",mind[j],".",ptype, sep="")
              #x11(15,7)
              # replace by pdf device
              pdf(outpdf1, width = 20, height = 15, pointsize = 20)
              
              par(mfrow=c(1,1),oma = c(0, 0, 3, 0))
            }
          }
          ## set default breaks for histogram
          if (missing(breaks))
          {
            breaks <- length(BM$betaSam[mind[j],((i-1)*ind+1):(i*ind)])%/%3
            if (breaks <=0)
              breaks <- length(BM$betaSam[mind[j],((i-1)*ind+1):(i*ind)])
          }    
          hist(t(BM$betaSam[mind[j],((i-1)*ind+1):(i*ind)]),col="gray",
               main = paste("Relative concentration\nfor ",r[mind[j]],sep=""),
               xlab = "Relative Concentration", breaks = breaks)
          v<-quantile(BM$betaSam[mind[j],((i-1)*ind+1):(i*ind)],p = c(2.5,97.5)/100, type = 3)
          abline(v = v, col = "red", lty=2, lwd = 2)
          legend("topright", legend = "2.5% & 97.5% quantiles",
                 col = "red", pt.cex=2, lty =  2, cex = 0.8)
          if (((f == j || !(j%%n))) && saveFig) 
          {
            title(main = list(paste("NMR Spectrum ",sno[i], ": ", BM$specTitle[2,i], sep=""),cex=1.5,font=3), outer=TRUE)                
            #if (file.exists(outpdf1) && !overwriteFig)
            #  cat("Can't save figure, file", outpdf1, "already exists.\n")
            #else
            #  df = dev.copy2pdf(device=x11, file = outpdf1)
            dev.off()
          }
        }
      } else {
        ## set subplot             
        if ((i%%n)==1)
        {
          if ((length(sno)-i)>=1) 
          {
            if (!missing(prefixFig))
              outpdf1 <- paste(saveFigDir, "/", prefixFig,"_spec_",sno[i],"to", sno[min(i+n-1,length(sno))],"RelCon.",ptype, sep="")
            else
              outpdf1 <- paste(saveFigDir,"/spec_",sno[i],"to", sno[min(i+n-1,length(sno))],"RelCon.",ptype, sep="")	
            #x11(15,7)
            # replace by pdf device
            pdf(outpdf1, width = 20, height = 15, pointsize = 20)
            
            par(mfrow=c(2, 2),oma = c(0, 0, 0, 0))	
          } else {
            if (!missing(prefixFig))
              outpdf1 <- paste(saveFigDir, "/", prefixFig, "_spec_",sno[i],"RelCon.",ptype, sep="")
            else
              outpdf1 <- paste(saveFigDir,"/spec_",sno[i],"RelCon.",ptype, sep="")
            #x11(15,7)
            # replace by pdf device
            pdf(outpdf1, width = 20, height = 15, pointsize = 20)
            
            par(mfrow=c(1,1),oma = c(3, 0, 0, 0))
          }
        }
        boxplot(as.data.frame(t(BM$betaSam[mind,((i-1)*ind+1):(i*ind)])), 
                main = paste("NMR Spectrum ",sno[i], ": ", BM$specTitle[2,i], sep=""), 
                names = as.character(r[mind]),
                ylab="Relative Concentration", xaxt="n") 
        axis(1,at=1:length(mind),adj=1,padj=0.5,labels=as.character(r[mind]), las=2)
        
        ## save plot
        if (((length(sno) == i || !(i%%n))) && saveFig) 
        {
          #title(main = list("NMR Spectrum Relative Concentration",cex=1.5,font=3), outer=TRUE)                
          #if (file.exists(outpdf1) && !overwriteFig)
          #  cat("Can't save figure, file", outpdf1, "already exists.\n")
          #else
          #  df = dev.copy2pdf(device=x11, file = outpdf1)
          dev.off()
        }
      }
    }
  }
  ## plot batman rerun results
  else if (!is.null(BM$betaSamRerun) && rerun) 
  {  
    #f<-nrow(BM$betaSamRerun)
    f<-length(mind)
    fc<-ncol(BM$betaSamRerun)
    sno<-BM$specRange
    ind<-fc/length(sno)
    r<-row.names(BM$betaSamRerun)
    outpdf2<-NULL
    for (i in 1:length(sno)) 
    {                                    
      if (plotHist)
      {
        for (j in 1:f)
        {   
          ## set subplot
          if ((j%%n)==1)
          {
            if ((f-j)>=1) 
            {
              if (!missing(prefixFig))
                outpdf2 <- paste(saveFigDir, "/", prefixFig,"_RelConRerun_", mind[j], "to",mind[min(j+n-1,length(mind))],"_Rerun",".",ptype,sep="")
              else
                outpdf2 <- paste(saveFigDir,"/RelConRerun_",mind[j], "to",mind[min(j+n-1,length(mind))],"_Rerun",".",ptype, sep="")	
              #x11(15,7)
              # replace by pdf device
              pdf(outpdf2, width = 20, height = 15, pointsize = 20)
              
              par(mfrow=c(2, 2),oma = c(0, 0, 3, 0))				
            } else {
              if (!missing(prefixFig))
                outpdf2 <- paste(saveFigDir, "/", prefixFig, "_RelConRerun_", mind[j], "_Rerun",".",ptype,sep="")
              else
                outpdf2 <- paste(saveFigDir,"/RelConRerun_",mind[j],"_Rerun",".",ptype, sep="")
              #x11(15,7)
              # replace by pdf device
              pdf(outpdf2, width = 20, height = 15, pointsize = 20)
              
              par(mfrow=c(1,1),oma = c(0, 0, 3, 0))	
            }
          }
          ## set default breaks
          if (missing(breaks))
          {
            breaks <- length(BM$betaSamRerun[mind[j],((i-1)*ind+1):(i*ind)])%/%3
            if (breaks <=0)
              breaks <- length(BM$betaSamRerun[mind[j],((i-1)*ind+1):(i*ind)])
          }                
          hist(t(BM$betaSamRerun[mind[j],((i-1)*ind+1):(i*ind)]),col="gray",
               main = paste("Relative concentration\nfor ",r[mind[j]],sep=""),
               xlab = "Relative Concentration", breaks = breaks)
          v<-quantile(BM$betaSamRerun[mind[j],((i-1)*ind+1):(i*ind)],p = c(2.5,97.5)/100, type = 3)
          abline(v = v, col = "red", lty=2, lwd = 2)
          legend("topright", legend = "2.5% & 97.5% quantiles",  col = "red",  pt.cex=2, lty =  2, cex = 0.8)
          if (((f == j || !(j%%n))) && saveFig) 
          {
            title(main = list(paste("NMR Spectrum ",sno[i], ": ", BM$specTitle[2,i], sep=""),cex=1.5,font=3), outer=TRUE)                
            #if (file.exists(outpdf2) && !overwriteFig)
            #  cat("Can't save figure, file", outpdf2, "already exists.\n")
            #else
            #  df = dev.copy2pdf(device=x11, file = outpdf2)
            dev.off()
          }
        }
      } else {
        ## set subplot
        if ((i%%n)==1)
        {
          if ((length(sno)-i)>=1) 
          {
            if (!missing(prefixFig))
              outpdf2 <- paste(saveFigDir, "/", prefixFig,"_spec_",sno[i],"to", sno[min(i+n-1,length(sno))],"RelCon_Rerun.",ptype, sep="")
            else
              outpdf2 <- paste(saveFigDir,"/spec_",sno[i],"to", sno[min(i+n-1,length(sno))],"RelCon_Rerun.",ptype,sep="")	
            #x11(15,7)
            # replace by pdf device
            pdf(outpdf2, width = 20, height = 15, pointsize = 20)
            
            par(mfrow=c(2, 2),oma = c(0, 0, 3, 0))	
          } else {
            if (!missing(prefixFig))
              outpdf2 <- paste(saveFigDir, "/", prefixFig, "_spec_",sno[i],"RelCon_Rerun.",ptype, sep="")
            else
              outpdf2 <- paste(saveFigDir,"/spec_",sno[i],"RelCon_Rerun.",ptype,sep="")
            #x11(15,7)
            # replace by pdf device
            pdf(outpdf2, width = 20, height = 15, pointsize = 20)
            
            par(mfrow=c(1,1),oma = c(0, 0, 3, 0))
          }
        }
        boxplot(as.data.frame(t(BM$betaSamRerun[mind,((i-1)*ind+1):(i*ind)])), 
                main = paste("NMR Spectrum ",sno[i], ": ", BM$specTitle[2,i], sep=""), 
                names = as.character(r[mind]),
                ylab="Relative Concentration", xaxt="n") 
        axis(1,at=1:length(mind),adj=1,padj=0.5,labels=as.character(r[mind]), las=2)
        
        ## save plot
        if (((length(sno) == i || !(i%%n))) && saveFig) 
        {
          #title(main = list(paste("NMR Spectrum ",i, ": ", BM$specTitle[2,i], "(Rerun)",sep=""),cex=1.5,font=3), outer=TRUE)                
          #if (file.exists(outpdf2) && !overwriteFig)
          #  cat("Can't save figure, file", outpdf2, "already exists.\n")
          #else
          #  df = dev.copy2pdf(device=x11, file = outpdf2)
          dev.off()
        }
      }
    }
  } else {
    cat("No results found.\n")
  }
  warnRead<-options(warn = warnDef)
}