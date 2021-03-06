//HCMACOMP JOB 241901,'COB GENERATE',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
//       REGION=0M
//****************************************************************************
//* Copyright 2019 IBM Corp. All Rights Reserved.
//*
//*  Licensed under the Apache License, Version 2.0 (the "License");
//*  you may not use this file except in compliance with the License.
//*  You may obtain a copy of the License at
//*
//*       http://www.apache.org/licenses/LICENSE-2.0
//*
//*   Unless required by applicable law or agreed to in writing, software
//*   distributed under the License is distributed on an "AS IS" BASIS,
//*   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//*   See the License for the specific language governing permissions and
//*   limitations under the License.
//****************************************************************************
// SET HLQ=IBMUSER
// SET CICSHLQ=DFH520.CICS
//* SET DSNAHLQ=DSNB10.DBBG
// SET DB2HLQ=DSNB10
// SET COBHLQ=IGY510
// SET LINKHLQ=DFH520.CICSA
//*-------------------------------------------------------------------*
//DB2PROC  PROC
//*-------------------------------------------------------------------*
//*  INVOKE THE COBOL COMPILE                                         *
//*-------------------------------------------------------------------*
//*
//COBL     EXEC PGM=IGYCRCTL,
// PARM='NODYNAM,LIB,RENT,APOST,LIB,CICS(''SP''),SQL,SIZE(4000K)'
//STEPLIB  DD DSN=&COBHLQ..SIGYCOMP,DISP=SHR
//         DD DSN=&CICSHLQ..SDFHLOAD,DISP=SHR
//*         DD DSN=&DSNAHLQ..SDSNEXIT,DISP=SHR
//         DD DSN=&DB2HLQ..SDSNEXIT,DISP=SHR
//*         DD DSN=&DSNAHLQ..RUNLIB.LOAD,DISP=SHR
//         DD DSN=&DB2HLQ..SDSNLOAD,DISP=SHR
//SYSLIB   DD DSN=&CICSHLQ..SDFHCOB,DISP=SHR
//         DD DSN=&CICSHLQ..SDFHMAC,DISP=SHR
//         DD DSN=&CICSHLQ..SDFHSAMP,DISP=SHR
//         DD DSN=&DB2HLQ..SDSNSAMP,DISP=SHR
//         DD DSN=&DB2HLQ..SDSNMACS,DISP=SHR
//         DD DSN=&HLQ..ZMOBILE.COPYLIB,DISP=SHR
//SYSIN    DD DISP=SHR,DSN=&HLQ..ZMOBILE.COBOL(&MEM)
//DBRMLIB  DD DSN=&HLQ..ZMOBILE.DBRMLIB(&MEM),DISP=SHR
//SYSLIN   DD DSN=&&LOADSET,DISP=(NEW,PASS),UNIT=SYSDA,
//         SPACE=(TRK,(20,10))
//SYSADATA DD DUMMY
//SYSMDECK DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT1   DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT2   DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT3   DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT4   DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT5   DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT6   DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT7   DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT8   DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT9   DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT10  DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT11  DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT12  DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT13  DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT14  DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSUT15  DD UNIT=SYSDA,SPACE=(460,(350,100))
//SYSPRINT DD SYSOUT=*
//*-------------------------------------------------------------------*
//*  REBLOCK DFHEILIA, FOR USE BY THE LINKEDIT STEP                   *
//*-------------------------------------------------------------------*
//*
//COPYLINK EXEC PGM=IEBGENER,COND=(7,LT,COBL)
//SYSUT1   DD DISP=SHR,DSN=&CICSHLQ..SDFHCOB(DFHEILIC)
//SYSUT2   DD DISP=(NEW,PASS),DSN=&&COPYLINK,
//            DCB=(LRECL=80,BLKSIZE=3120,RECFM=FB),
//            UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//*-------------------------------------------------------------------*
//*  INVOKE THE MVS LINKAGE-EDITOR PROGRAM                            *
//*-------------------------------------------------------------------*
//*
//LKED     EXEC PGM=HEWL,COND=(7,LT,COBL),
//  PARM='LIST,XREF,RENT,NAME=&MEM'
//SYSLIB   DD DISP=SHR,DSN=&CICSHLQ..SDFHLOAD
//         DD DSN=&DB2HLQ..SDSNLOAD,DISP=SHR
//         DD DSN=CEE.SCEELKED,DISP=SHR
//SYSLMOD  DD DISP=SHR,DSN=&LINKHLQ..LOAD(&MEM)
//SYSUT1   DD UNIT=SYSDA,DCB=BLKSIZE=1024,
//            SPACE=(CYL,(1,1))
//SYSPRINT DD SYSOUT=*
//SYSLIN   DD DISP=(OLD,DELETE),DSN=&&COPYLINK
//         DD DISP=(OLD,DELETE),DSN=&&LOADSET
//         DD DISP=SHR,DSN=&HLQ..ZMOBILE.JCL(LINKPARM)
//         PEND
//*
//*common programs
//HCAZMENU EXEC DB2PROC,MEM=HCAZMENU
//HCAZERRS EXEC DB2PROC,MEM=HCAZERRS
//*patient inquire, add
//HCP1BI01 EXEC DB2PROC,MEM=HCP1BI01
//HCP1BA01 EXEC DB2PROC,MEM=HCP1BA01
//HCP1PL01 EXEC DB2PROC,MEM=HCP1PL01
//HCIPDB01 EXEC DB2PROC,MEM=HCIPDB01
//HCAPDB01 EXEC DB2PROC,MEM=HCAPDB01
//HCAPDB02 EXEC DB2PROC,MEM=HCAPDB02
//HCPRESTW EXEC DB2PROC,MEM=HCPRESTW
//*medications inquire
//HCM1BI01 EXEC DB2PROC,MEM=HCM1BI01
//HCM1PL01 EXEC DB2PROC,MEM=HCM1PL01
//HCIMDB01 EXEC DB2PROC,MEM=HCIMDB01
//HCMRESTW EXEC DB2PROC,MEM=HCMRESTW
//*medication add
//HCMABA01 EXEC DB2PROC,MEM=HCMABA01
//HCMAPL01 EXEC DB2PROC,MEM=HCMAPL01
//HCMADB01 EXEC DB2PROC,MEM=HCMADB01
//HCMADB02 EXEC DB2PROC,MEM=HCMADB02
//*patient visit
//HCV1PL01 EXEC DB2PROC,MEM=HCV1PL01
//HCV1BI01 EXEC DB2PROC,MEM=HCV1BI01
//HCV1BA01 EXEC DB2PROC,MEM=HCV1BA01
//HCIVDB01 EXEC DB2PROC,MEM=HCIVDB01
//HCAVDB01 EXEC DB2PROC,MEM=HCAVDB01
//*threshold inquire, add
//HCITDB01 EXEC DB2PROC,MEM=HCITDB01
//HCATDB01 EXEC DB2PROC,MEM=HCATDB01
//HCT1BA01 EXEC DB2PROC,MEM=HCT1BA01
//HCT1BI01 EXEC DB2PROC,MEM=HCT1BI01
//HCT1PL01 EXEC DB2PROC,MEM=HCT1PL01
//HCTRESTW EXEC DB2PROC,MEM=HCTRESTW