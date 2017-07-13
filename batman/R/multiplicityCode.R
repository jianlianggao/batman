multiplicityCode<-function(coupleCode)
{
  ## Written by Dr. Jianliang Gao, Imperial College London.
  ## Converting couple_code of BATMAN into nominal symbols.
  
  ## dictionary of multiplicity code
  multipletNum<-c("s","d","t","q","quint","sext","sept")
  
  ## conver R factor object to character
  if (is.factor(coupleCode))
  {
    coupleCode<-as.character(coupleCode)
  }
  
 
  ##split the character and save in a list
  temp<-unlist(strsplit(coupleCode,","))
  tempCode<-""
  for (i in 1:length(temp))
  {
    tempIndex<-as.numeric(temp[i])+1
    if (tempIndex>0) 
    {  
         tempCode<-paste(tempCode, multipletNum[tempIndex], sep = "", collapse = "")
    }
    else
    {
      tempCode<-"m"
    }
  }
  return (tempCode)
}