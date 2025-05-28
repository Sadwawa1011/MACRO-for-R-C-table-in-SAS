
/*===========================================================================*
Program Name        :  * RC_table.sas*
Path                :  *���򱣴��·��*
Program Language    :  SAS V9.4
______________________________________________________________________________

Purpose             : * *

Macro Calls         : * *


Input               : ��
Output              : ��

Program Flow        : *��̲���*

     *1.  ����R*C��Ƶ���ĳ��� *

______________________________________________________________________________


==========================================================================*/





/* ---------------------------------------------R*C�����----------------------------------------------- */

%macro rc_table(indata ,outdata ,var1,var2 ,var1txt =%str(),var2txt = %str(),
freqyn=0,freqtype=%str(total),perfmt=percent9.1,misstxt=%str(ȱʧ),rowtxt_suffix=%str()
,delimiter=" " )/parmbuff;
    

/* �������ڣ������������ע�� */
%window RC_table_winname_tem1 

    #5 @8 '========================================================��RC_table����ע��=============================================================='
    #7 @16 'RC_table: RC��Ƶ��Ƶ�ʼ���' color=red
    #9 @16 '������' color=red
    #11 @18 'indata             : �������ݼ������ڷ��������ݼ����ƣ����' color=blue
    #13 @18 'outdata            : ������ݼ������ڳ��ַ�����������ݼ����ƣ����' color=blue
    #15 @18 'var1               : ���Ŀ�����������ı���ʽ�����' color=blue
    #17 @18 'var1txt            : ���Ŀ��������-���ݷ����ı�������ָ���ض��ķ�������������ÿո������������˳�����򣩣���var1txt=%str(���� �쳣 δ��)'
    #19 @18 'var2               : �ݱ�Ŀ�����������ı���ʽ�����' color=blue
    #21 @18 'var2txt            : �ݱ�Ŀ��������-���ݷ����ı�������ָ���ض��ķ�������������ÿո������������˳�����򣩣���var2txt=%str(������ ������ ��ο����)'
    #23 @18 'freqyn             : �Ƿ����Ƶ�ʣ�Ĭ��Ϊ��freqyn=0�������㣩����freqyn=1ʱ����Ƶ�ʣ�����Ϊ"n(%)"'
    #25 @18 'freqtype           : Ƶ�ʼ������ͣ�֧�����ַ�ʽ��total-�ܺϼƣ�col-�кϼƣ�line-�кϼƣ���Ĭ��Ϊ��freqtype=%str(total)��������RC���ܺϼƽ��м���'
    #27 @18 'perfmt             : Ƶ�ʸ�ʽ��Ĭ��Ϊ��percent9.1'
    #29 @18 'misstxt            : var1/var2������� ����ȱʧֵ����ı���Ĭ��Ϊ��misstxt=%str(ȱʧ)'
    #31 @18 'rowtxt_suffix      : ���Ŀ���������ֺ�׺��Ĭ��Ϊ��rowtxt_suffix=%str()���磺������1��n(%)��'
    #33 @18 'delimiter          : ����ָ�������ʹ��var1txt/var2txtʱ����ָ���ض��ķָ�����Ĭ��Ϊ"�ո�"�����Ķ��Ž��鲻��Ϊ�ָ���,��ASCII�ַ��Ĵ������һЩ�������⣩��'         


    #36 @16 '��ע��' color=red
    #38 @18 '1.�˺�������R��C�������Ƶ�ʣ�'
    #40 @18 '2.ʹ��var1txt/var2txtָ������ʱ��ͨ���ո���������࣬����var1txt/var2txtָ���ķ���˳����ֽ����'
    #42 @18 '3.ʹ��var1txt/var2txtָ������ʱ��������ָ���÷����������ܻ�����ܺϼ������ݼ�������ƥ����������'
    #44 @18 '4.ͨ�����%rc_table; �� %rc_table(); ��%rc_table(help) ��������ע�ʹ��ڡ�'

    #50 @16 '��ʷ�汾��' color=red
    #52 @18 'V1.0, on 2023-07-05 ; Author: liu sheng ; �汾�������°汾'
    #54 @18 'V2.0, on 2024-05-30 ; Author: liu sheng ; �汾�������������ּ���Ƶ�ʵķ��� "freqtype=%str()"��total-�ܺϼƣ�col-�кϼƣ�line-�кϼƣ�'
    #56 @18 'V3.0, on 2024-06-26 ; Author: liu sheng ; �汾����������var1/2txt��ָ����������£��Զ���ȡ�������'
    #58 @18 'V4.0, on 2024-08-07 ; Author: liu sheng ; �汾�������޸�������࣬�з��า�ǵ����⣨ѭ���������ͬ�������⣩'
    #60 @18 'V5.0, on 2024-08-23 ; Author: liu sheng ; �汾�����������з����׺��ǩ'
    #62 @18 'V6.0, on 2025-03-31 ; Author: liu sheng ; �汾��������� �����ı������� ���С�%����������'

    #68 @8 '========================================================================================================================================='

/* ���ڽ��� */
;
/* �򿪲���ע�ͣ�parmbuff��Syspbuff����Q���������������ַ����˴���Ҫ������������"" */
%if %length(&Syspbuff)=0 or %bquote(&Syspbuff) = %bquote(()) or  %qupcase(&Syspbuff) = %bquote((HELP)) %then %do; 
    %display RC_table_winname_tem1  ;
%end;

%else %do;


/* ͳһ��д */
%let freqtype=%sysfunc( upcase(&freqtype) ) ;
/*%put freqtype= &freqtype ;*/



/* ----------------�������ݼ�-------------- */
/* ȱʧ�Ϊ&misstxt��%superq()ֱ�ӻ�ȡ�������ֵ���������κκ���� */
proc sql noprint;
    create table indata as
        select  
            coalescec(&var1,"%superq(misstxt)" ) as &var1,
            coalescec(&var2,"%superq(misstxt)" ) as &var2
        from &indata ;
quit;
run;


/* ----------��ȡ���Ŀ���ݱ�Ŀ�ķ�����------------- */
/* ��var1/2txt�ı�û��ָ��,���Զ���ȡ */
%if %length(&var1txt)=0 %then %do;
    /* ��ȡ�з���-ȱʧ���Ϊ&misstxt */
    proc sql noprint;
        create table rowcat1 as
        select
            distinct( &var1 ) as rowcat
        from indata; 
    quit;
    data _null_;
        set rowcat1 end=last;
        /* �з���-������ */
        call symputx(cats("v1txt",_n_),rowcat );
        if last then call symput("var1_n",_n_);
    run;
    proc delete data=rowcat1;
    quit;
%end;
%else %do;
    /* ��-��:����ָ�������ȡ������ */
    data _null_;
        txt = symget('var1txt');delimiter = symget('delimiter');
        n = countw(txt, delimiter) ;
      call symputx('var1_n', n);
    run;
/*    %let var1_n = %eval(%sysfunc(countw(&var1txt, %unquote(%superq(delimiter)) )) + 1);*/
%end;

%if %length(&var2txt)=0 %then %do;
    /* ��ȡ�з���-ȱʧ���Ϊ&misstxt */
    proc sql noprint;
        create table linecat1 as
        select
            distinct( &var2 ) as linecat
        from indata; 
    quit;
    data _null_;
        set linecat1 end=last;
        /* �з���-������ */
        call symputx(cats("v2txt",_n_),linecat );
        if last then call symput("var2_n",_n_);
    run;
    proc delete data=linecat1;
    quit;
%end;
%else %do;
    /* ��-��:����ָ�������ȡ������ */
    data _null_;
        txt = symget('var2txt');delimiter = symget('delimiter');
        n = countw(txt, delimiter) ;
      call symputx('var2_n', n);
    run;
%end;


/* ------------------ѭ������------------ */
/* ���� */
data _null_;
    if 0 then set indata nobs=n;
    call symput("n_tol",n);
run;


/* �� */
%do i=1 %to &var1_n;
    %if %length(&var1txt)>0 %then %do;
        %put a-2 ;
        %let v1txt&i = %qtrim( %qscan( %superq(var1txt),&i,%unquote(%superq(delimiter)) ) ) ;
        %put a-1 ;
    %end;

    /* ��Ƕ�ݱ�Ŀѭ��: symget()�����ڰ��������ַ��ĺ����ֵ */
    /* �� */
    %do j=1 %to &var2_n;
        %if %length(&var2txt)>0 %then %do;
            %let v2txt&j = %qtrim( %qscan(%superq(var2txt),&j,%unquote(%superq(delimiter)) ) );
        %end;
        proc sql noprint;
            select count(*) into : n_rc&i&j
            from indata where &var1 = symget( cats('v1txt',&i)) and &var2 = symget( cats('v2txt',&j))
        ; quit;
    %end;

%end;




/* ------------------------------�������ݼ�--------------------- */
%let var1_tol_n = %eval(&var1_n+1) ;
%let var2_tol_n = %eval(&var2_n+1) ;
/* �к��е��ܺϼƱ�ǩ */
%let v1txt&var1_tol_n = �ϼ� ;
%let v2txt&var2_tol_n = �ϼ� ;


/* ���ɺ��Ŀ�ȿ�� %doѭ�����ɱ�����%str()��֤������֮���пո� */
/*option symbolgen mlogic mprint;*/
data out_form;
    length  seq 8. cate $200. ;
    %do i=1 %to &var1_n;
        seq=&i ; cate=strip( symget(cats('v1txt',&i)) )||"&rowtxt_suffix" ; output;
    %end;
    seq= &var1_tol_n ; cate="�ϼ�"||"&rowtxt_suffix" ; output;
run;

data &outdata;
    set out_form;
    length  %do j=1 %to &var2_tol_n; value&j $200. %str() %end; TOTALN 8;
    /* ��ֵ���� */
    if seq= &var1_tol_n then do;
        %do j=1 %to &var2_n;
            /* �кϼƹ۲��£���j�����ĺϼ� */
            value&j= strip(put( %do i=1 %to &var1_n ;&&n_rc&i&j + %end;0 ,8.));
            label value&j= "%superq(v2txt&j)" ;
        %end;
            /* �ܺϼ� */
            value&var2_tol_n= strip(put( %do j=1 %to &var2_n ;value&j + %end;0 ,8.));
            label value&var2_tol_n="�ϼ�";
    end;
    else do;
    %do m=1 %to &var1_n ;
        %do k=1 %to &var2_n ;
            if seq=&m then do;
                /* �ڲ�RC��������� */
                value&k = strip("&&n_rc&m&k");
            end;
        %end;
            if seq=&m then do;
                /* ÿ�кϼ� */
                value&var2_tol_n = strip(put( %do j=1 %to &var2_n ;value&j + %end;0 ,8.));
            end;
    %end;
    end;
    TOTALN=&n_tol;
    label TOTALN="�������ݼ���������";
run;




/*option nosymbolgen nomlogic nomprint;*/
/* ----------------�Ƿ����Ƶ��------------------ */
%if &freqyn=1 %then %do;

    /* undo_policy=none:���� create��ͬ���ݼ����Ƶ�warning */
    proc sql noprint undo_policy=none;
        create table &outdata as
            select
                seq,
                cate,
                %do j=1 %to &var2_tol_n;
                    (case
                        when count("&freqtype","TOTAL")>0 and sum(input(value&var2_tol_n,8.))>0 then strip(value&j)||"("||strip( put(input(value&j ,8.)/(sum(input(value&var2_tol_n,8.))/2),&perfmt.) )||")"
                        when count("&freqtype","TOTAL")>0 and sum(input(value&var2_tol_n,8.))=0 then strip(value&j)||"("||strip( put(0,&perfmt.) )||")"

                        when count("&freqtype","LINE")>0 and sum(input(value&j,8.))>0 then strip(value&j)||"("||strip( put(input(value&j ,8.)/(sum(input(value&j,8.))/2),&perfmt.) )||")"
                        when count("&freqtype","LINE")>0 and sum(input(value&j,8.))=0 then strip(value&j)||"("||strip( put(0,&perfmt.) )||")"

                        when count("&freqtype","COL")>0 and input(value&var2_tol_n,8.)>0 then strip(value&j)||"("||strip( put(input(value&j ,8.)/input(value&var2_tol_n,8.),&perfmt.) )||")"
                        when count("&freqtype","COL")>0 and input(value&var2_tol_n,8.)=0 then strip(value&j)||"("||strip( put(0,&perfmt.) )||")"
                        else strip(value&j)
                    end)                as value&j      length=200      label="%superq(v2txt&j)"    ,
                %end;
                TOTALN
        from &outdata;
    quit;
%end;


/* -----------ɾ����������----------- */
proc delete data= indata out_form;
quit;
run;

/* ����ע���������� */
%end;

%mend ;


