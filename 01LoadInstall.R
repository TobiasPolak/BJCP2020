# 1. Installing and loading packages
rm(list = ls())
packages <-
  list(
    'gsheet',
    'urltools',
    'RCurl',
    'stringr',
    'rvest',
    'XML',
    'readxl',
    'stringr',
    'dplyr',
    'parsedate',
    'gt',
    'gtsummary',
    'gridExtra',
    'ggpubr',
    'ggforce',
    'glue',
    'lubridate',
    'knitr',
    'hrbrthemes',
    'ggthemes',
    'naniar',
    'flextable',
    'ggsci',
    'pdftools',
    'readr',
    'tesseract'
  )


lapply(packages, require, character.only = TRUE)
theme_gtsummary_language("en", big.mark = "")

`%notin%` <- Negate(`%in%`)

words <-  c(
  'compassionate',
  'expanded access',
  'early access',
  'early access to medicines',
  ' ATU ',
  'single patient IND',
  'single-patient IND',
  'treatment IND ',
  'emergency IND ',
  'named-patient',
  'named patient',
  'pre-approval access',
  'pre approval access',
  'autorisations temporaires utilisation',
  'autorisation termporaire utilisation',
  ' EAP ',
  'special access',
  'managed access'
)