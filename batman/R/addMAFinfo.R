addMAFinfo<-function(multi_data_file,list_file )
{
  metaboList<-read.csv(list_file, header=F,colClasses="character")
  
  temp_metabolite<-read.csv(multi_data_file)
  temp_metabolite$flag2 <- with(temp_metabolite, match(Metabolite, unique(Metabolite)))
  metabolite_attr<-vector()
  metabolite_attr<-data.frame(Metabolite=numeric(0),chemical_shift=numeric(0), multiplicity=numeric(0))
  for (i in 1:max(temp_metabolite$flag2))
  {
    newrow<-nrow(metabolite_attr)+1
    for (j in 1:dim(temp_metabolite)[1])
      if ((temp_metabolite[j,]$flag2)==i)
      {
        metabolite_attr[newrow,]$Metabolite<-paste(temp_metabolite[j, "Metabolite"])
        if (!is.na(metabolite_attr[newrow,]$chemical_shift)) 
        {
          metabolite_attr[newrow,]$chemical_shift<-paste(metabolite_attr[newrow,]$chemical_shift,"_",temp_metabolite[j,"pos_in_ppm"],sep="")
        } 
        else 
        {
          metabolite_attr[newrow,]$chemical_shift<-paste(temp_metabolite[j,"pos_in_ppm"])
        }
        if (!is.na(metabolite_attr[newrow,]$multiplicity))
        {
          tempCode<-multiplicityCode(temp_metabolite[j,"couple_code"])
          metabolite_attr[newrow,]$multiplicity<-paste(metabolite_attr[newrow,]$multiplicity,"_",tempCode,sep="")
        }
        else
        {
          tempCode<-multiplicityCode(temp_metabolite[j,"couple_code"])
          metabolite_attr[newrow,]$multiplicity<-paste(tempCode)
        }
      }
  }
  
  #add more columns to the output
  metabolite_attr<-cbind(chemical_formula="", smiles="",inchi="", metabolite_attr, taxid="", species="", database="HMDB", database_version="", reliability="")
  
  meta_ids_tmp<-cbind(temp_metabolite['Metabolite'],temp_metabolite['database_identifier'],temp_metabolite['uri'])
  
  #remove the duplicated rows
  meta_ids_tmp1<-unique(meta_ids_tmp)
  rownames(meta_ids_tmp1)<-seq(length=nrow(meta_ids_tmp1))
  
  colnames(metaboList)[1]<-"Metabolite"
  meta_ids_tmp2<-merge(meta_ids_tmp1, metaboList, by="Metabolite", sort = FALSE)
  
  Metabolite1<-merge(metabolite_attr, meta_ids_tmp2, by.y="Metabolite", sort=FALSE)
  
  #add more columns
  Metabolite1<-cbind(Metabolite1,search_engine="",search_engine_score="",smallmolecule_abundance_sub="",smallmolecule_abundance_stdev_sub="",smallmolecule_abundance_std_error_sub="")
  #change column name
  colnames(Metabolite1)[1]<-"metabolite_identification"
  #re order the columns
  Metabolite1<-Metabolite1[c(12, 2,3,4,1,5,6,7,8,9,10,11,13,14,15,16,17,18)]
  
  return (Metabolite1)
}