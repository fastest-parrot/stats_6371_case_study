{"version":2,"type":"import","id":"716a2c2e-f2e7-4388-82d9-e642982e3f90","name":"Import Data 1","label":"Import Data 1","description":"","created":1565207901773,"modified":1565207930873,"notes":"","parameters":{"server":"","target":"com.sas.ep.sascoder.execution.producers.VPP","action":"runSASCode","priority":"Reserved","code":"/* Generated Code (IMPORT) */\r\n/* Source File: test.csv */\r\n/* Source Path: /home/u38439810/Case Study Stats 6371 */\r\n/* Code generated on: 8/7/19, 3:58 PM */\r\n\r\n%web_drop_table(WORK.housing_test);\r\n\r\n\r\nFILENAME REFFILE '/home/u38439810/Case Study Stats 6371/test.csv';\r\n\r\nPROC IMPORT DATAFILE=REFFILE\r\n\tDBMS=CSV\r\n\tOUT=WORK.housing_test;\r\n\tGETNAMES=YES;\r\nRUN;\r\n\r\nPROC CONTENTS DATA=WORK.housing_test; RUN;\r\n\r\n\r\n%web_open_table(WORK.housing_test);","resource":false,"outputType":"TABLE","outputName":"housing_test","outputLocation":"WORK","fileName":"test.csv","filePath":"/home/u38439810/Case Study Stats 6371","fileType":"","fileSheet":"","fileTable":"","delimiterOption":"","dataRowOption":-1,"guessingRowsOption":-1,"getnamesOption":true,"quoteDelimiterOption":true,"eolDelimiterOption":""},"properties":{"left":"20","top":"20","width":"100","height":"60","region":"output","fillcolor":"#E0E6F1","linecolor":"#6882a3","tooltip":"","portsonly":false,"key":"control","visible":true}}