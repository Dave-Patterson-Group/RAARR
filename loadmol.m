function [molstats, allcases] = loadmol(molid)

molstats.DK = 0;
molstats.DJK = 0;
molstats.DJ = 0;
molstats.deltaK = 0;
molstats.deltaJ = 0;
        
switch molid 
    
    case 'generic'
       
        molstats.a = 10000;
        molstats.b = 8000; % in units of GHz
        molstats.c = 5000;  %this is 1-2 propanediol
        molstats.DK = 0;
        molstats.DJK = 0; % distortion constants in units of MHz
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'generic';
        molstats.conformer = 1; %this IS actually conformer 3
        molstats.color = 'r';
    case 'annso'
        molstats.a = 553.80105 / 1000;
        molstats.b = 359.73363 / 1000; % in units of GHz
        molstats.c = 277.57441 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'annso';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';     
     case 'fluorobenzene'
        
        molstats.a = 5663.713 / 1000;
        molstats.b = 2570.6531 / 1000;
        molstats.c = 1767.9136 / 1000;  %this is carvone EQ1
        
        molstats.mua = 1.6;
        molstats.mub = 0;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
   

   %     molstats.AllowComplex= 1;
        molstats.molname = 'fluorobenzene';  
    case 'pent1'
       
        molstats.a = 15644.213960 / 1000;
        molstats.b = 1136.193887  / 1000; % in units of GHz
        molstats.c = 1097.914562 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0;
        molstats.DJK = 00; % distortion constants in units of MHz
        molstats.DJ = 00;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 0;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'pent1';
        molstats.conformer = 2; %this IS actually conformer 3
        molstats.color = 'r';
        
     case 'pent2'
        %III-D) A     = 8947.966372           B     = 1345.504933           C     = 1250.464296
%DK    = 0.0000e+00            DJK   = -1.3447e-03           DJ    = 1.9511e-04
%dK    = 0.0000e+00            dJ    = 3.3422e-05    
        molstats.a = 15928.312294 / 1000;
        molstats.b = 1136.339041  / 1000; % in units of GHz
        molstats.c = 1098.266977 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0;
        molstats.DJK = 00; % distortion constants in units of MHz
        molstats.DJ = 00;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 0;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'pent2';
        molstats.conformer = 2; %this IS actually conformer 3
        molstats.color = 'r';
        
     case 'pent3'
        %III-D) A     = 8947.966372           B     = 1345.504933           C     = 1250.464296
%DK    = 0.0000e+00            DJK   = -1.3447e-03           DJ    = 1.9511e-04
%dK    = 0.0000e+00            dJ    = 3.3422e-05    
        molstats.a = 9151.9205 / 1000;
        molstats.b = 1373.988635  / 1000; % in units of GHz
        molstats.c = 1278.9537 / 1000;  %this is 1-2 propanediol
        molstats.DK = .041727 / 1000;
        molstats.DJK = -0.0031392 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.00023945 / 1000;
        molstats.deltaK = .0016496 / 1000;
        molstats.deltaJ = 0.00004274 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'pent3';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
    case 'pulegone2'
        molstats.a = 1819.907 / 1000;
        molstats.b = 816.6853  / 1000; % in units of GHz
        molstats.c = 635.94683 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0 / 1000;
        molstats.deltaJ = 0 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'pulegon1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
    case 'pulegone1'
        molstats.a = 1908.49298 / 1000;
        molstats.b = 738.85952  / 1000; % in units of GHz
        molstats.c = 578.1415 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0 / 1000;
        molstats.deltaJ = 0 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'pulegon1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
    case 'pent4'
        %III-D) A     = 8947.966372           B     = 1345.504933           C     = 1250.464296
%DK    = 0.0000e+00            DJK   = -1.3447e-03           DJ    = 1.9511e-04
%dK    = 0.0000e+00            dJ    = 3.3422e-05    
        molstats.a = 9182.534770 / 1000;
        molstats.b = 1357.763838 / 1000; % in units of GHz
        molstats.c = 1262.3455 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.08636 / 1000;
        molstats.DJK = -0.002672 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.00023709 / 1000;
        molstats.deltaK = 0.000 / 1000;
        molstats.deltaJ = 0.000061375 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'pent4';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
      
        case 'eucalyptol'  %melanies constants
        %III-D) A     = 8947.966372           B     = 1345.504933           C     = 1250.464296
%DK    = 0.0000e+00            DJK   = -1.3447e-03           DJ    = 1.9511e-04
%dK    = 0.0000e+00            dJ    = 3.3422e-05    
        molstats.a = 1545.887 / 1000;
        molstats.b = 1080.4679 / 1000; % in units of GHz
        molstats.c = 1038.9331 / 1000; 
        molstats.DK = -0.00003 / 1000;
        molstats.DJK = 0.00002 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.000023709 / 1000;
        molstats.deltaK = 0.000 / 1000;
        molstats.deltaJ = 0.00000 / 1000;
        
        molstats.mua = 0;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'eucalyptal';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
      case 'cineole'  %melanies constants
        molstats.a = 2035.4639 / 1000;
        molstats.b = 842.273 / 1000; % in units of GHz
        molstats.c = 778.630 / 1000;  %this is 1-2 propanediol
        molstats.DK = -0.00000 / 1000;
        molstats.DJK = 0.00000 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.00000 / 1000;
        molstats.deltaK = 0.000 / 1000;
        molstats.deltaJ = 0.00000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'cineole';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
                case 'camphor'  %Big Z's constants from 10.1039/B212029A   
        molstats.a = 1446.698977 / 1000;
        molstats.b = 1183.367110 / 1000; % in units of GHz
        molstats.c = 1097.101031 / 1000; 
        molstats.DK = -0.00006558 / 1000;
        molstats.DJK = 0.000083681 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.0000334804 / 1000;
        molstats.deltaK = 0.0000028637 / 1000;
        molstats.deltaJ = 0.000024858 / 1000;
        
        molstats.mua = 0;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'camphor';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
                   case 'linalool'  %Big Z's constants from 10.1039/B212029A   
        molstats.a = 1646.74020 / 1000;
        molstats.b = 682.19862 / 1000; % in units of GHz
        molstats.c = 618.75100 / 1000; 
        molstats.DK = 0 / 1000;
        molstats.DJK = 0.0003843 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.0001155 / 1000;
        molstats.deltaK = 0.000234 / 1000;
        molstats.deltaJ = 0.00000435 / 1000;
        
        molstats.mua = 0;
        molstats.mub = 1;
        molstats.muc = 0;  
        
        molstats.molname = 'linalool';
        molstats.color = 'r';
        
              
        case 'heptaldehyde1'
         molstats.a = 7813.98 / 1000;
        molstats.b = 572.42 / 1000; % in units of GHz
        molstats.c = 544.72 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'heptaldehyde1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
          case 'test3'
         molstats.a = 5000 / 1000;
        molstats.b = 1750 / 1000; % in units of GHz
        molstats.c = 1350 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'test3';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
        case 'test1'
         molstats.a = 5000 / 1000;
        molstats.b = 1680 / 1000; % in units of GHz
        molstats.c = 1420 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'test1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
         case 'test2'
         molstats.a = 5500 / 1000;
        molstats.b = 1650 / 1000; % in units of GHz
        molstats.c = 1450 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'test2';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
         case 'test2floppy'
         molstats.a = 7000 / 1000;
        molstats.b = 1650 / 1000; % in units of GHz
        molstats.c = 1450 / 1000;  %this is 1-2 propanediol
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'test1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
        molstats.DK = .024 / 1000;
        molstats.DJK = 0.002 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.001 / 1000;
        molstats.deltaK = 0.001 / 1000;
        molstats.deltaJ = 0.0003 / 1000;
        
        case 'test4'
         molstats.a = 3000 / 1000;
        molstats.b = 1630 / 1000; % in units of GHz
        molstats.c = 1470 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'test1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
         case 'test6'
         molstats.a = 3000 / 1000;
        molstats.b = 1800 / 1000; % in units of GHz
        molstats.c = 1300 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'test1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
        case 'test5'
         molstats.a = 1500 / 1000;
        molstats.b = 700 / 1000; % in units of GHz
        molstats.c = 500 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'test5';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
        case 'angelica'
         molstats.a = 6041.2302 / 1000;
        molstats.b = 2240.1566 / 1000; % in units of GHz
        molstats.c = 1668.313 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'angelica';
        
        case 'ethylguiacol'
         molstats.a = 1640.45 / 1000;
        molstats.b = 802.45 / 1000; % in units of GHz
        molstats.c = 567.84 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'ethylguiacol';
        
        case 'cinnamylalcohol'
         molstats.a = 4298.7 / 1000;
        molstats.b = 562.30 / 1000; % in units of GHz
        molstats.c = 513.75 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'cinnamylalcohol';
        
        case 'terpineol1'
         molstats.a = 2329.30 / 1000;
        molstats.b = 618.97 / 1000; % in units of GHz
        molstats.c = 560.39 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'alpha-terpineol 1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
        case 'hexanalnot'
         molstats.a = 9735.59 / 1000;
        molstats.b = 868.845 / 1000; % in units of GHz
        molstats.c = 818.518 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0;
        molstats.DJK = 0; % distortion constants in units of MHz
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanalnot';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
        case 'hexanalrigid'
         molstats.a = 9769.63045 / 1000;
        molstats.b = 868.84588 / 1000; % in units of GHz
        molstats.c = 818.518 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.00 / 1000;
        molstats.DJK = 0.000 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.000 / 1000;
        molstats.deltaK = 0.000 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanalrigid';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
        case 'skinnytrouble'
         molstats.a = 7451.4 / 1000;
        molstats.b = 830.8 / 1000; % in units of GHz
        molstats.c = 806.7 / 1000;  %this is 1-2 propanediol
        molstats.DK = .024 / 1000;
        molstats.DJK = 0.002 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.001 / 1000;
        molstats.deltaK = 0.001 / 1000;
        molstats.deltaJ = 0.0003 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'skinny';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
         case 'hexanalbare'
         molstats.a = 9735.59 / 1000;
        molstats.b = 868.85 / 1000; % in units of GHz
        molstats.c = 818.510 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.000 / 1000;
        molstats.DJK = 0.000 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.000 / 1000;
        molstats.deltaK = 0.000 / 1000;
        molstats.deltaJ = 0.000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanal1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
        case 'hexanal1'
         molstats.a = 9769.63045 / 1000;
        molstats.b = 868.84588 / 1000; % in units of GHz
        molstats.c = 818.518 / 1000;  %this is 1-2 propanediol
        molstats.DK = .024 / 1000;
        molstats.DJK = 0.002 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.001 / 1000;
        molstats.deltaK = 0.001 / 1000;
        molstats.deltaJ = 0.0003 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanal1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
    
        
        
        
      case 'hexanal2'
         molstats.a = 5399.89 / 1000;
        molstats.b = 1143.24 / 1000; % in units of GHz
        molstats.c = 1028.99 / 1000;  %this is 1-2 propanediol
        molstats.DK = .014 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanal1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
    case 'hexanal3'
         molstats.a = 8975.49 / 1000;
        molstats.b = 933.43 / 1000; % in units of GHz
        molstats.c = 898.08 / 1000;  %this is 1-2 propanediol
        molstats.DK = .072 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanal13';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';    
   case 'hexanal4'
         molstats.a = 5995.206 / 1000;
        molstats.b = 1046.739 / 1000; % in units of GHz
        molstats.c = 945.971 / 1000;  %this is 1-2 propanediol
        molstats.DK = .018 / 1000;
        molstats.DJK = 0 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanal4';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';    
    case 'hexanal5'
         molstats.a = 6116.502 / 1000;
        molstats.b = 1167.3003 / 1000; % in units of GHz
        molstats.c = 1059.541 / 1000;  %this is 1-2 propanediol
        molstats.DK = .0178 / 1000;
        molstats.DJK = -.002 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanal5';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r'; 
    case 'hexanal6'
         molstats.a = 4667.6175 / 1000;
        molstats.b = 1336.769 / 1000; % in units of GHz
        molstats.c = 1166.123 / 1000;  %this is 1-2 propanediol
        molstats.DK = .0207 / 1000;
        molstats.DJK = -.005 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanal6';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';     
    case 'hexanal7'
         molstats.a = 5455.608 / 1000;
        molstats.b = 1055.756 / 1000; % in units of GHz
        molstats.c = 937.27 / 1000;  %this is 1-2 propanediol
        molstats.DK = .041 / 1000;
        molstats.DJK = -.005 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanal7';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r'; 
    case 'hexanal8'
         molstats.a = 4827.9103 / 1000;
        molstats.b = 1240.841 / 1000; % in units of GHz
        molstats.c = 1159.91 / 1000;  %this is 1-2 propanediol
        molstats.DK = .040 / 1000;
        molstats.DJK = -.005 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'hexanal8';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';     
    case 'guac'
        molstats.a = 1640.45 / 1000;
        molstats.b = 802.454 / 1000; % in units of GHz
        molstats.c = 567.84 / 1000;  %this is 1-2 propanediol
%         molstats.DK = 0.0000 / 1000;
%         molstats.DJK = 0 / 1000; % distortion constants in units of MHz
%         molstats.DJ = 0 / 1000;
%         molstats.deltaK = 0.00 / 1000;
%         molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'benzOH1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
    case 'benzOD1'
         molstats.a = 4678.9317326 / 1000;
        molstats.b = 1442.9604 / 1000; % in units of GHz
        molstats.c = 1169.2206 / 1000;  %this is 1-2 propanediol
        molstats.DK = -1.38e-3 / 1000;
        molstats.DJK = 3.1611e-03 / 1000; % distortion constants in units of MHz
        molstats.DJ = 1.54189e-04 / 1000;
        molstats.deltaK = -0.3e-3 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'benzOD1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
     case 'benzOD2'
         molstats.a = 4667.4299 / 1000;
        molstats.b = 1452.1060 / 1000; % in units of GHz
        molstats.c = 1163.6514 / 1000;  %this is 1-2 propanediol
        molstats.DK = -1.44e-3 / 1000;
        molstats.DJK = 2.9011e-03 / 1000; % distortion constants in units of MHz
        molstats.DJ = 2.8889e-04 / 1000;
        molstats.deltaK = -2.44e-3 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'benzOD1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
      case 'benzOH1'
         molstats.a = 4678.960326 / 1000;
        molstats.b = 1442.955701 / 1000; % in units of GHz
        molstats.c = 1169.219333 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.0000 / 1000;
        molstats.DJK = 3.202021e-03 / 1000; % distortion constants in units of MHz
        molstats.DJ = 1.175189e-04 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'benzOH1';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';   
     case 'benzOH2'
         molstats.a = 4667.418335 / 1000;
        molstats.b = 1452.086940 / 1000; % in units of GHz
        molstats.c = 1163.652390 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.0000 / 1000;
        molstats.DJK = 2.888046e-03 / 1000; % distortion constants in units of MHz
        molstats.DJ = 1.637668e-04 / 1000;
        molstats.deltaK = 0.00 / 1000;
        molstats.deltaJ = 0.0000 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'benzOH2';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
     case '13prop'
        %III-D) A     = 8947.966372           B     = 1345.504933           C     = 1250.464296
%DK    = 0.0000e+00            DJK   = -1.3447e-03           DJ    = 1.9511e-04
%dK    = 0.0000e+00            dJ    = 3.3422e-05 
%https://ac.els-cdn.com/S0022285285711289/1-s2.0-S0022285285711289-main.pdf?_tid=d1706b3c-a631-11e7-9ba6-00000aab0f02&acdnat=1506812035_8c14a070a2ec3252336e244cc8b1cfb1
        molstats.a = 7701.232 / 1000;
        molstats.b = 3891.298 / 1000; % in units of GHz
        molstats.c = 2854.556 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.00239 / 1000;
        molstats.DJK = 0.00012 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.00023709 / 1000;
        molstats.deltaK = 0.004 / 1000;
        molstats.deltaJ = 0.00007 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 0;
        molstats.muc = 0;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = '1,3 propanediol from Camninati';
        molstats.conformer = 1; %t
        molstats.color = 'r';

        case 'pent5'
 % A     = 9330.579234           B     = 1471.774296           C     = 1363.472674
% DK    = 0.0000e+00            DJK   = -2.1912e-03           DJ    = 2.3821e-04
% dK    = 0.0000e+00            dJ    = 3.4582e-05          
 
        molstats.a = 9330.5792 / 1000;
        molstats.b = 1471.774 / 1000; % in units of GHz
        molstats.c = 1363.4726 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.00 / 1000;
        molstats.DJK = -0.00219 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.000238 / 1000;
        molstats.deltaK = 0.000 / 1000;
        molstats.deltaJ = 0.000045 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'pent5';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
    case 'Dpent3'
        %III-D) A     = 8947.966372           B     = 1345.504933           C     = 1250.464296
%DK    = 0.0000e+00            DJK   = -1.3447e-03           DJ    = 1.9511e-04
%dK    = 0.0000e+00            dJ    = 3.3422e-05    
        molstats.a = 8947.888112 / 1000;
        molstats.b = 1345.507967 / 1000; % in units of GHz
        molstats.c = 1250.459244 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.032898 / 1000;
        molstats.DJK = -0.0025095 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.00021514 / 1000;
        molstats.deltaK = 0.0019845 / 1000;
        molstats.deltaJ = 0.0000359 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'Dpent3';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
    case 'Dpent4' %from Cristobal April 25
        %III-D) A     = 8947.966372           B     = 1345.504933           C     = 1250.464296
%DK    = 0.0000e+00            DJK   = -1.3447e-03           DJ    = 1.9511e-04
%dK    = 0.0000e+00            dJ    = 3.3422e-05    
        molstats.a = 8812.226057 / 1000;
        molstats.b = 1352.2967 / 1000; % in units of GHz
        molstats.c = 1266.195 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.035372 / 1000;
        molstats.DJK = -0.0025095 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.00022937 / 1000;
        molstats.deltaK = 0.002418 / 1000;
        molstats.deltaJ = 0.00003802 / 1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  %1-2 propanediol; quite a bit of uncertainty here.
        
        molstats.molname = 'Dpent4';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
    case {1,'prop3'}    
        molstats.a = 8572.0553 / 1000;
        molstats.b = 3640.1063 / 1000; % in units of GHz
        molstats.c = 2790.9666 / 1000;  %this is 1-2 propanediol
        molstats.DK = 0.00253 / 1000;
        molstats.DJK = 0.005276 / 1000; % distortion constants in units of MHz
        molstats.DJ = 0.000738 / 1000;
        molstats.deltaK = 0.00318 / 1000;
        molstats.deltaJ = 0.0001631 / 1000;
        
        molstats.mua = 1.21;
        molstats.mub = 2.10;
        molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = '1,2-propanediol Conf. 3';
       % molstats.molname = 'prop3';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
case 701    
        molstats.a = 8.5720553;
        molstats.b = 3.6401063; % in units of GHz
        molstats.c = 2.7909666;  %this is 1-2 propanediol
        molstats.DK = 0;
        molstats.DJK = 0; % distortion constants in units of MHz
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1.21;
        molstats.mub = 2.10;
        molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = '1-2 propanediol Conformer 3 no centrip';
        molstats.molname = 'prop3';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
case {101,'prop3,13C3'}    
        molstats.a = 8485.725/1e3;
        molstats.b = 3625.759/1e3; % in units of GHz
        molstats.c = 2775.135/1e3;  %this is 1-2 propanediol
        molstats.DK = 0.00253/1e3;
        molstats.DJK = 0.005276/1e3; % distortion constants in units of MHz
        molstats.DJ = 0.000738/1e3;
        molstats.deltaK = 0.00318/1e3;
        molstats.deltaJ = 0.0001631/1e3;
        
        molstats.mua = 1.21;
        molstats.mub = 2.10;
        molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = '1-2 propanediol Conf 3,13c3';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';

case {102,'prop3,13C4'}     
        molstats.a = 8555.920/1e3;
        molstats.b = 3631.166/1e3; % in units of GHz
        molstats.c = 2787.564/1e3;  %this is 1-2 propanediol
        molstats.DK = 0.00253/1e3;
        molstats.DJK = 0.005276/1e3; % distortion constants in units of MHz
        molstats.DJ = 0.000738/1e3;
        molstats.deltaK = 0.00318/1e3;
        molstats.deltaJ = 0.0001631/1e3;
        
        molstats.mua = 1.21;
        molstats.mub = 2.10;
        molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = '1-2 propanediol Conf 3,13c4';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
        
case {103,'prop3,13C7'}      
        molstats.a = 8506.815/1e3;
        molstats.b = 3557.975/1e3; % in units of GHz
        molstats.c = 2735.709/1e3;  %this is 1-2 propanediol
        molstats.DK = 0.00253/1e3;
        molstats.DJK = 0.005276/1e3; % distortion constants in units of MHz
        molstats.DJ = 0.000738/1e3;
        molstats.deltaK = 0.00318/1e3;
        molstats.deltaJ = 0.0001631/1e3;
        
        molstats.mua = 1.21;
        molstats.mub = 2.10;
        molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = '1-2 propanediol Conf 3,13c7';
        molstats.conformer = 3; %this IS actually conformer 3
        molstats.color = 'r';
      
        

    case 104 
        molstats.a = 8314.741e-3;
        molstats.b = 3633.983e-3;
        molstats.c = 2763.027e-3;  %this is 1-2 propanediol #2
        molstats.DK = 0.00316/1e3;
        molstats.DJK = 0.0044851/1e3;
        molstats.DJ = 0.0007971/1e3;
        molstats.deltaK = 0.00314/1e3;
        molstats.deltaJ = 0.0001827/1e3;        
        
        molstats.mua = 2.64;
        molstats.mub = 0.28;
        molstats.muc = 0.57;  %1-2 propanediol; quite a bit of uncertainty here.
       % molstats.mass = 76 * AMU;
        molstats.molname = '1-2 propanediol #2 13C31 '; 
    
         case 'cinn2'

        molstats.a = 8866.41;
        molstats.b = 579.06;
        molstats.c = 517.81;  %this is carvone EQ1
        molstats.DK = 0;
        molstats.DJK = 0;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'cinn';
        molstats.conformer = 1;
        molstats.color = 'r';
    case 'rose1'
        molstats.a = 1400.9025;
        molstats.b = 1161.9887;
        molstats.c = 1089.45165;
        molstats.DK = 0;
        molstats.DJK = 0;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 0;
        molstats.muc = 1;  
        molstats.molname = 'rosemary1';
        molstats.conformer = 1;
        molstats.color = 'r';
    case 'cinn'

        molstats.a = 4866.41;
        molstats.b = 579.06;
        molstats.c = 517.81;  %this is carvone EQ1
        molstats.DK = 0;
        molstats.DJK = 0;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'cinn';
        molstats.conformer = 1;
        molstats.color = 'r';
    case 'cinnac'

        molstats.a = 4866.41;
        molstats.b = 579.06;
        molstats.c = 517.81;  %this is carvone EQ1
        molstats.DK = 0;
        molstats.DJK = 0;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 0;
        molstats.muc = 5;  
        molstats.molname = 'cinnac';
        molstats.conformer = 1;
        molstats.color = 'r';
   case 'cinnjusta'

        molstats.a = 4866.41;
        molstats.b = 579.06;
        molstats.c = 517.81;  %this is carvone EQ1
        molstats.DK = 0;
        molstats.DJK = 0;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 0;
        molstats.muc = 0;  
        molstats.molname = 'cinnac';
        molstats.conformer = 1;
        molstats.color = 'r';
    case 'oblate'

        molstats.a = 866.41;
        molstats.b = 679.06;
        molstats.c = 517.81;  %this is carvone EQ1
        molstats.DK = 0;
        molstats.DJK = 0;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'oblate';
        molstats.conformer = 0;
        molstats.color = 'r';    
   case 'bigoblate'

        molstats.a = 1866.41;
        molstats.b = 1679.06;
        molstats.c = 1217.81;  %this is carvone EQ1
        molstats.DK = 0;
        molstats.DJK = 0;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'bigoblate';
        molstats.conformer = 0;
        molstats.color = 'r';    
    case 2

        molstats.a = 2.2569;
        molstats.b = 0.6729;
        molstats.c = 0.5545;  %this is carvone EQ1
        molstats.DK = -0.00111;
        molstats.DJK = 0.0000312;
        molstats.DJ = 0.00001413;
        molstats.deltaK = -0.000363;
        molstats.deltaJ = 0.00000155;
        
        molstats.mua = 1.68;
        molstats.mub = 2.54;
        molstats.muc = 0.7;  
        molstats.molname = 'EQ1 Carvone';
        molstats.conformer = 1;
        molstats.color = 'r';
        
     case 3
        
        molstats.a = 2.2372;
        molstats.b = 0.65628;
        molstats.c = 0.57964;  %this is carvone EQ2
        molstats.DK = -0.0007562/1000;
        molstats.DJK = 0.0001487/1000;
        molstats.DJ = 0.00001246/1000;
        molstats.deltaK = -0.001308/1000;
        molstats.deltaJ = 0.00000449/1000;
        molstats.forcemaxj = 24;
        molstats.mua = 1.82;
        molstats.mub = 2.76;
        molstats.muc = 0.5;  
        molstats.molname = 'EQ2 Carvone';
        molstats.conformer = 2;
        molstats.color = 'b';
        
     case 4
         
        molstats.a = 2.21280;
        molstats.b = 0.68452;
        molstats.c = 0.55473;  %this is carvone EQ3
        molstats.DK = 0;
        molstats.DJK = 0;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1.54;
        molstats.mub = 2.27;
        molstats.muc = 0.32;  
        molstats.molname = 'EQ3 Carvone';
        molstats.conformer = 3;
        molstats.color = 'g';
        
        
        

     
    case 6
        molstats.a = 10.34787;
        molstats.b = 4.10236;
        molstats.c = 3.78195;  
        
        molstats.mua = 0.61;
        molstats.mub = 1.20;
        molstats.muc = 0.52;  
        molstats.molname = 'glycidol';
         
    case 7
        molstats.a = 7.948403;
        molstats.b = 3.640570;
        molstats.c = 2.747727;  
        
        molstats.mua = 3.0;
        molstats.mub = 0.54;
        molstats.muc = 0.57;  
        molstats.molname = 'alaninol-1';
    case 8
        molstats.a = 6.461620;
        molstats.b = 4.144442;
        molstats.c = 3.336136;  
        
        molstats.mua = 2.19;
        molstats.mub = 1.46;
        molstats.muc = 1.17;  
        molstats.molname = 'alaninol-2';
    case 9
        molstats.a = 6.54183;
        molstats.b = 2.26406;
        molstats.c = 1.81284;  
        
        molstats.mua = 2.00;
        molstats.mub = 1.8;
        molstats.muc = 0.5;  
        molstats.molname = '13butandiol-2';    

     case 11
        molstats.a = 1.699;
        molstats.b = 0.696;
        molstats.c = 0.561;  
        
        molstats.mua = 0.6;
        molstats.mub = 1.2;
        molstats.muc = 0.7;  
        molstats.molname = 'Tryptamine';  
     case 12
        molstats.a = 2.049;
        molstats.b = 0.584;
        molstats.c = 0.555;  
        
        molstats.mua = 1.5;
        molstats.mub = 0.4;
        molstats.muc = 2.6;  
        molstats.molname = 'Nicotine';  
        
    case 13
        molstats.a = 29.99792458 * 4.2537;
        molstats.b = 29.99792458 * 0.82357;
        molstats.c = 29.99792458 * 0.792538;  
        
        molstats.mua = 1.6;  %is it really A-type? internal motions?
        molstats.mub = 0;
        molstats.muc = 0;  
        molstats.molname = 'Methanol';  
        
    case 14
        molstats.a = 5655.2654/1e3;
        molstats.b = 1546.8758/1e3;
        molstats.c = 1214.4040/1e3;  
        
        molstats.mua = 4.5152;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        
        molstats.DK = 0;
        molstats.DJK = 0.937/1e3;
        molstats.DJ = .045/1e3;
        molstats.deltaK = .603/1e3;
        molstats.deltaJ = .0112/1e3;
        molstats.molname = 'Benznormal';  
        
    case 'benzlia'
        molstats.a = 5655.2121/1e3;
        molstats.b = 1500.56/1e3;
        molstats.c = 1185.87/1e3;  
        
        molstats.mua = 4.5152;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        
        molstats.DK = 0;
        molstats.DJK = 0.937/1e3;
        molstats.DJ = .045/1e3;
        molstats.deltaK = .603/1e3;
        molstats.deltaJ = .0112/1e3;
        molstats.molname = 'Benznormal';  
    case 114
        molstats.a = 5655.5075/1e3;
        molstats.b = 1545.55183/1e3;
        molstats.c = 1213.6014/1e3;  
        
        molstats.mua = 4.5152;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        
        molstats.DK = 0;
        molstats.DJK = 0.937/1e3;
        molstats.DJ = .045/1e3;
        molstats.deltaK = .603/1e3;
        molstats.deltaJ = .0112/1e3;
        molstats.molname = 'Benz_1C13';  
    case 115
        molstats.a = 5563.9185/1e3;
        molstats.b = 1546.8034/1e3;
        molstats.c = 1210.0897/1e3;  
        
        molstats.mua = 4.5152;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        
        molstats.DK = 0;
        molstats.DJK = 0.937/1e3;
        molstats.DJ = .045/1e3;
        molstats.deltaK = .603/1e3;
        molstats.deltaJ = .0112/1e3;
        molstats.molname = 'Benz_2C13';  
    case 116
        molstats.a = 5565.6669/1e3;
        molstats.b = 1535.7130/1e3;
        molstats.c = 1203.3730/1e3;  
        
        molstats.mua = 4.5152;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        
        molstats.DK = 0;
        molstats.DJK = 0.937/1e3;
        molstats.DJ = .045/1e3;
        molstats.deltaK = .603/1e3;
        molstats.deltaJ = .0112/1e3;
        molstats.molname = 'Benz_3C13';
    case 117
        molstats.a = 5655.4544/1e3;
        molstats.b = 1523.6552/1e3;
        molstats.c = 1200.0578/1e3;  
        
        molstats.mua = 4.5152;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        
        molstats.DK = 0;
        molstats.DJK = 0.937/1e3;
        molstats.DJ = .045/1e3;
        molstats.deltaK = .603/1e3;
        molstats.deltaJ = .0112/1e3;
        molstats.molname = 'Benz_4C13';    
    case 118
        molstats.a = 5655.2407/1e3;
        molstats.b = 1528.6407/1e3;
        molstats.c = 1203.1368/1e3;  
        
        molstats.mua = 4.5152;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        
        molstats.DK = 0;
        molstats.DJK = 0.937/1e3;
        molstats.DJ = .045/1e3;
        molstats.deltaK = .603/1e3;
        molstats.deltaJ = .0112/1e3;
        molstats.molname = 'Benz_7C13';   
    case 119
        molstats.a = 5655.270/1e3;
        molstats.b = 1502.14915/1e3;
        molstats.c = 1186.65856/1e3;  
        
        molstats.mua = 4.5152;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        
        molstats.DK = 0;
        molstats.DJK = 0.937/1e3;
        molstats.DJ = .045/1e3;
        molstats.deltaK = .603/1e3;
        molstats.deltaJ = .0112/1e3;
        molstats.molname = 'Benz_N15';  
    case 24
        molstats.a = 5.58099;
        molstats.b = .99036;
        molstats.c = .84148;  
        
        molstats.mua = 6.5152;  %from melanie's paper
        molstats.mub = 1; 
        molstats.muc = 1;  
        molstats.mass = 118;
        molstats.molname = 'ABN';  
    case {15,'menthone1'}
        molstats.a = 1.95343192;
        molstats.b = .694514561;
        molstats.c = .58657673;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 0;  
        molstats.molname = 'Menth1';  

        
        molstats.molname = 'menthone1';  
        case {15,'menthone1'}
        molstats.a = 1.95343192;
        molstats.b = .694514561;
        molstats.c = .58657673;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 0;  
        molstats.molname = 'Menth1';  

        
        molstats.molname = 'menthone1'; 
        
    case {'dioxolane'}
        molstats.a = 2750.5369;
        molstats.b = 1230.8359;
        molstats.c = 1076.6905;  
        
        molstats.DK = 0.0012;
        molstats.DJK = -0.000648;
        molstats.DJ = 0.000479;
        molstats.deltaK = -0.0000233;
        molstats.deltaJ = 0.000112;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'dioxolane';  
    case {'dioxolane2'}
        molstats.a = 2870.550955;
        molstats.b = 1201.4624;
        molstats.c = 1125.47327;  
        
        molstats.DK = 0.00048;
        molstats.DJK = -0.000314;
        molstats.DJ = 0.000297;
        molstats.deltaK = 0.000743;
        molstats.deltaJ = 0.00006;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'dioxolane2';  
        
    case {'bs1'}
        molstats.a = 2000;
        molstats.b = 1500;
        molstats.c = 1200;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 0;  
        molstats.molname = 'bs1';
    case {'bs2'}
        molstats.a = 2000.523;
        molstats.b = 1523.573;
        molstats.c = 1151.17;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 0;  
        molstats.molname = 'bs1';
        
    case {'fakementh'}
        molstats.a = 1.95343192;
        molstats.b = .694514561;
        molstats.c = .58657673;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 0;  
        molstats.molname = 'Fakementh'; 
      case {'fakementh2'}
        molstats.a = 2953.43192;
        molstats.b = 794.514561;
        molstats.c = 586.57673;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 0;  
        molstats.molname = 'Fakementh2'; 
    case {'fakementh2abc'}
        molstats.a = 2.95343192 * 1000;
        molstats.b = .794514561 * 1000;
        molstats.c = .58657673 * 1000;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'Fakementh2bc';
    case {'fakementh2bc'}
        molstats.a = 2.95343192 * 1000;
        molstats.b = .794514561 * 1000;
        molstats.c = .58657673 * 1000;  
        
        molstats.mua = 0;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'Fakementh2bc';
    case {'fakementh2ac'}
        molstats.a = 2.95343192 * 1000;
        molstats.b = .794514561 * 1000;
        molstats.c = .58657673 * 1000;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 1;  
        molstats.molname = 'Fakementh2ac';
    case {16,'menthone2'}
        molstats.a = 2.02198414;
        molstats.b = .693535995;
        molstats.c = .562135763;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 4;
        molstats.muc = 1;  
        molstats.molname = 'MenthoneSuccess2';
    case {'menthCD'}
        molstats.a = 2021.98414;
        molstats.b = 693.535995;
        molstats.c = 562.135763;  
        
        molstats.DK = 0.002;
        molstats.DJK = 0.002;
        molstats.DJ = 0.002;
        molstats.deltaK = 0.002;
        molstats.deltaJ = 0.002;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'MenthoneSuccess2';
    case {'menthliteCD'}
        molstats.a = 2021.98414;
        molstats.b = 693.535995;
        molstats.c = 562.135763;  
        
        molstats.DK = -0.00151;
        molstats.DJK = 0.001354;
        molstats.DJ = 0.001774;
        molstats.deltaK = 0.00174;
        molstats.deltaJ = 0.000267;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'MenthoneSuccess2';
   case 'myrtenal'
       
          molstats.a = 1666.41;
        molstats.b = 962.37;
        molstats.c = 836.90;  
        
        molstats.DK = -0.0001;
        molstats.DJK = 0.00005;
        molstats.DJ = 0.0001;
        molstats.deltaK = 0.000100;
        molstats.deltaJ = 0.00005;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 0;  
        molstats.molname = 'Myrtenal';
   case 'myrtenalbigac'
       
          molstats.a = 1666.41;
        molstats.b = 962.37;
        molstats.c = 836.90;  
        
        molstats.DK = -0.0001;
        molstats.DJK = 0.00005;
        molstats.DJ = 0.0001;
        molstats.deltaK = 0.000100;
        molstats.deltaJ = 0.00005;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 2;  
        molstats.molname = 'Myrtenalbigac';
   case 'weirdac'
       
          molstats.a = 1000;
        molstats.b = 470;
        molstats.c = 380;  
       
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 1;  
        molstats.molname = 'weird1000_470_380_ac';
      case 'nopinone'
       
          molstats.a = 1923.2;
        molstats.b = 1297.6;
        molstats.c = 1164.0;  
        
        molstats.DK =     0.0001;
        molstats.DJK =   -0.00004;
        molstats.DJ =     0.00006;
        molstats.deltaK = -0.000100;
        molstats.deltaJ = 0.000001;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'nopinone';
        
    case 'alphapinene'
       
          molstats.a = 1936.558;
        molstats.b = 1228.635;
        molstats.c = 1127.020;  
        
        molstats.DK =     0.0001;
        molstats.DJK =   -0.00004;
        molstats.DJ =     0.00006;
        molstats.deltaK = -0.000100;
        molstats.deltaJ = 0.000001;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'alpha_pinene';
        
            case 'alphapinene'
       
          molstats.a = 1936.558;
        molstats.b = 1228.635;
        molstats.c = 1127.020;  
        
        molstats.DK =     0.0001;
        molstats.DJK =   -0.00004;
        molstats.DJ =     0.00006;
        molstats.deltaK = -0.000100;
        molstats.deltaJ = 0.000001;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'alpha_pinene';
        
        case 'benzaldehyde'
       
          molstats.a = 5234.28;
        molstats.b = 1564.29;
        molstats.c = 1204.68;  
       
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        
    case 'twisty'
       
        molstats.a = 5873.49337;
        molstats.b = 982.494081;
        molstats.c = 776.14728;  
        
        molstats.DK = -0.0003;
        molstats.DJK = 0.0005;
        molstats.DJ = 0.001;
        molstats.deltaK = 0.0007;
        molstats.deltaJ = 0.001;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'twisty';    
    case {'menthveryliteCD'}
        molstats.a = 2021.98414;
        molstats.b = 693.535995;
        molstats.c = 562.135763;  
        
        molstats.DK = -0.0001;
        molstats.DJK = 0.00005;
        molstats.DJ = 0.0001;
        molstats.deltaK = 0.000100;
        molstats.deltaJ = 0.00005;
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = 'MenthoneSuccess2';
    case 17
        molstats.a = 30000;
        molstats.b = 29.99 * 3.67;
        molstats.c = 29.99 * 3.67;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        molstats.molname = 'Diatomic SrH';
    case {18,'prop1'}
        molstats.a = 6.6424488;
        molstats.b = 4.1635949;
        molstats.c = 3.3653627;  %this is 1-2 propanediol
        molstats.DK = -0.00451 / 1000;
        molstats.DJK = 0.006354 / 1000;
        molstats.DJ = 0.001774 / 1000;
        molstats.deltaK = 0.00174 /1000;
        molstats.deltaJ = 0.000267 /1000;
        
        molstats.mua = 2.35;
        molstats.mub = 0.3;
        molstats.muc = 0.7;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = 'prop1';
        molstats.conformer = 1;
        molstats.color = 'b';
    case {19,'prop2'}
        molstats.a = 8.3934003;
        molstats.b = 3.6485661;
        molstats.c = 2.7782963;  %this is 1-2 propanediol
        molstats.DK = 0.00316 / 1000;
        molstats.DJK = 0.004485 /1000;
        molstats.DJ = 0.000797 / 1000;
        molstats.deltaK = 0.00314 / 1000;
        molstats.deltaJ = 0.0001827 / 1000;        
        
        molstats.mua = 2.496;
        molstats.mub = 0.309;
        molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = 'prop2';
        molstats.shortname = 'prop2';
        molstats.conformer = 2;
        molstats.color = 'y';
    case 219
        molstats.a = 8.314741;
        molstats.b = 3.633983;
        molstats.c = 2.763027;  %this is 1-2 propanediol
        molstats.DK = 0.00316  / 1000;
        molstats.DJK = 0.004485 / 1000;
        molstats.DJ = 0.000797 / 1000;
        molstats.deltaK = 0.00314 / 1000;
        molstats.deltaJ = 0.0001827 / 1000;        
        
        molstats.mua = 2.496;
        molstats.mub = 0.309;
        molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = '1-2 propanediol Conf 2, 13C3';
        molstats.conformer = 2;
        molstats.color = 'y';
    case 220
        molstats.a = 8.377518;
        molstats.b = 3.639168;
        molstats.c = 2.774789;  %this is 1-2 propanediol
        molstats.DK = 0.00316;
        molstats.DJK = 0.004485 / 1000;
        molstats.DJ = 0.000797 / 1000;
        molstats.deltaK = 0.00314 / 1000;
        molstats.deltaJ = 0.0001827 / 1000;        
        
        molstats.mua = 2.496;
        molstats.mub = 0.309;
        molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = '1-2 propanediol Conf 2, 13C4';
        molstats.conformer = 2;
        molstats.color = 'y';
    case 221
        molstats.a = 8.327826;
        molstats.b = 3.565701;
        molstats.c = 2.723004;  %this is 1-2 propanediol
        molstats.DK = 0.00316 / 1000;
        molstats.DJK = 0.004485 / 1000;
        molstats.DJ = 0.000797 / 1000;
        molstats.deltaK = 0.00314 / 1000;
        molstats.deltaJ = 0.0001827 / 1000;        
        
        molstats.mua = 2.496;
        molstats.mub = 0.309;
        molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = '1-2 propanediol Conf 2, 13C7?';
        molstats.conformer = 2;
        molstats.color = 'y';
    case {21,'prop5'}
        molstats.a = 8.53677;
        molstats.b = 3.604198;
        molstats.c = 2.778331;  %this is 1-2 propanediol
        molstats.DK = 0.00275 / 1000;
        molstats.DJK = 0.00529 / 1000;
        molstats.DJ = 0.000751 / 1000;
        molstats.deltaK = 0.00334 / 1000;
        molstats.deltaJ = 0.000152 / 1000;       
  
        molstats.mua = 0.41;
        molstats.mub = 1.86;
        molstats.muc = 1.51;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = 'prop5';
        molstats.conformer = 5;
        molstats.color = 'c';
    case {22,'prop6'}
        molstats.a = 8.327599;
        molstats.b = 3.642001;
        molstats.c = 2.776902;  %this is 1-2 propanediol
        molstats.DK = 0.0028 / 1000;
        molstats.DJK = 0.0051 / 1000;
        molstats.DJ = 0.00076 / 1000;
        molstats.deltaK = 0.0029 / 1000;
        molstats.deltaJ = 0.00024 / 1000;          
        
        molstats.mua = 2.26;
        molstats.mub = 0.7;
        molstats.muc = 1.2;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = 'prop6';
        molstats.conformer = 6;
        molstats.color = 'k';
    case {23,'prop7'}
        molstats.a = 6.627612;
        molstats.b = 4.146287;
        molstats.c = 3.363345;  %this is 1-2 propanediol
        molstats.DK = -0.005 / 1000;
        molstats.DJK = 0.0062 / 1000;
        molstats.DJ = 0.00184 / 1000;
        molstats.deltaK = 0.0018 / 1000;
        molstats.deltaJ = 0.00023 / 1000;   
        
        molstats.mua = 0.98;
        molstats.mub = 0.8;
        molstats.muc = 1.91;  %1-2 propanediol; quite a bit of uncertainty here.
        molstats.molname = 'prop7';
        molstats.conformer = 7;
        molstats.color = [1.0 0.5 0.3];
        
    case 'but1'
        molstats.a = 6.6049080;
        molstats.b = 2.2290431;
        molstats.c = 1.8153657;
        molstats.DK = 0;
        molstats.DJK = 0.29 * 1e-3 / 1000;
        molstats.DJ = 0.37 * 1e-3 / 1000;
        molstats.deltaK = 0;
        molstats.deltaJ = 0.06 * 1e-3 / 1000;
        
        molstats.mua = 6.9;
        molstats.mub = 1;
        molstats.muc = 6.9/3; % These numbers were measured, but they are off from the calculated. DUBIOUS
        molstats.molname = '1,3-butanediol Conf 1';
        molstats.conformer = 1;
        molstats.color = [0 0 1];
        
    case 26
        molstats.a = 6.5418393;
        molstats.b = 2.2640596;
        molstats.c = 1.8128437;
        molstats.DK = 0;
        molstats.DJK = 0.53 * 1e-3;
        molstats.DJ = 0.36 * 1e-3;
        molstats.deltaK = 0;
        molstats.deltaJ = 0.089 * 1e-3;
        
        molstats.mua = 1.1;
        molstats.mub = 1;
        molstats.muc = 1.1/4;
        molstats.molname = '1,3-butanediol Conf 2';
        molstats.conformer = 2;
        molstats.color = [0 0.5 0];
        
    case 27
        molstats.a = 6.544798;
        molstats.b = 2.2414905;
        molstats.c = 1.8081532;
        molstats.DK = 0;
        molstats.DJK = 0.66 * 1e-3;
        molstats.DJ = 0.33 * 1e-3;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 0.6;
        molstats.mub = 1;
        molstats.muc = 0.6/4;
        molstats.molname = '1,3-butanediol Conf 3';
        molstats.conformer = 3;
        molstats.color = [1 0 0];
        
    case 28
        molstats.a = 6.497768;
        molstats.b = 2.2398548;
        molstats.c = 1.8098292;
        molstats.DK = 0;
        molstats.DJK = 0.37 * 1e-3;
        molstats.DJ = 0.35 * 1e-3;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 3;
        molstats.mub = 1;
        molstats.muc = 3 / 10;
        molstats.molname = '1,3-butanediol Conf 4';
        molstats.conformer = 4;
        molstats.color = [0 0.75 0.75];
        
    case 29
        molstats.a = 5.169682;
        molstats.b = 2.525132;
        molstats.c = 2.152733;
        molstats.DK = 0;
        molstats.DJK = -1.3 * 1e-3;
        molstats.DJ = 1.71 * 1e-3;
        molstats.deltaK = 0;
        molstats.deltaJ = -0.11 * 1e-3;
        
        molstats.mua = 3.79;
        molstats.mub = -1.04;
        molstats.muc = 0.01;
        molstats.molname = '1,3-butanediol Conf 6';
        molstats.conformer = 5; %Conformer 5 is not observed in the paper, but for the purposes of code this will be known as conf 5
        molstats.color = [0.75 0.75 0];
        
    case 30
        molstats.a = 1.84498735;
        molstats.b = 1.305135870;
        molstats.c = 1.0878419;
        molstats.DK = 0;
        molstats.DJK = 0;
        molstats.DJ = 0.0000646;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        
        molstats.mua = 1.4;
        molstats.mub = 0.9;
        molstats.muc = 1.0;
        molstats.molname = 'Ribose Conformer A';
        molstats.conformer = 1;
        molstats.color = 'r';
    case 31    
        molstats.a = 7.096729;
        molstats.b = 6.976339;
        molstats.c = 4.008201;
        
        molstats.DK = -.0109/1000;
        molstats.DJK = .0092/1000;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        molstats.conformer = 1;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'THFv=0';
        
    case 32    
        molstats.a = 7.092788;
        molstats.b = 6.98286;
        molstats.c = 4.008356;
        
        molstats.DK = -.0032/1000;
        molstats.DJK = .00262/1000;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        molstats.conformer = 1;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'THFv=1';
    case 33    
        molstats.a = 7131.297/1000;
        molstats.b = 6920.427/1000;
        molstats.c = 3998.977/1000;
        
        molstats.DK = -.0053/1000;
        molstats.DJK = -.00683/1000;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        molstats.conformer = 1;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'THFv=2';
        
    case 34    
        molstats.a = 7127.920/1000;
        molstats.b = 6926.919/1000;
        molstats.c = 3997.018/1000;
        
        molstats.DK =  .0024/1000;
        molstats.DJK = -.0041/1000;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        molstats.conformer = 1;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'THFv=3';
   case 35    
        molstats.a = 7114.672/1000;
        molstats.b = 6943.789/1000;
        molstats.c = 4007.024/1000;
        
        molstats.DK = -0.015/1000;
        molstats.DJK = .01397/1000;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        molstats.conformer = 1;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'THFv=4';
        
    case 36    
        molstats.a = 7123.69/1000;
        molstats.b = 6931.98/1000;
        molstats.c = 3929.83/1000;
        
        molstats.DK =  -.083/1000;
        molstats.DJK = 0/1000;
        molstats.DJ = 0;
        molstats.deltaK = 0;
        molstats.deltaJ = 0;
        molstats.conformer = 1;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'THFv=5';
    case 37
        molstats.a = 45;
        molstats.b = 8.5458425;
        molstats.c = 8.5458425;  
        
        molstats.mua = 0.71521;  
        molstats.mub = 0.65;
        molstats.muc = 0;  
        molstats.molname = 'methylacetylene';

    case 38
        molstats.a = 4758.986/1e3; % in GHz
        molstats.b = 1475.398/1e3;
        molstats.c = 1193.4018/1e3;
        
        molstats.DK = -1.723 /1e6; % in MHz
        molstats.DJK = -2.494/1e6;
        molstats.DJ = -0.0819/1e6;
        molstats.deltaJ = -0.1741/1e6;
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1; 
        molstats.molname = 'benzyl alcohol';
    
    case 'amineprop'
        molstats.a = 8487.1037/1000;
        molstats.b = 3564.3804/1000;
        molstats.c = 2767.2212/1000;
        
        molstats.DK = 2.947/1000;
        molstats.DJK = 4.237/1000;
        molstats.DJ = 0.6577/1000;
        molstats.deltaK = 0.1311/1000;
        molstats.deltaJ = 2.411/1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = '1-amino-2-propanol';
        
    case 40
        molstats.a = 7948.403/1000;
        molstats.b = 3640.570/1000;
        molstats.c = 2747.727/1000;
        
        molstats.DK = 1.5/1000;
        molstats.DJK = 3.84/1000;
        molstats.DJ = 0.51/1000;
        molstats.deltaK = 3.23/1000;
        molstats.deltaJ = 0.163/1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = '2-amino-1-propanol conf 1';
        
    case 41
        molstats.a = 6461.620/1000;
        molstats.b = 4144.442/1000;
        molstats.c = 3336.163/1000;
        
        molstats.DK = -7.02/1000;
        molstats.DJK = 6.35/1000;
        molstats.DJ = 1.65/1000;
        molstats.deltaK = -0.034/1000;
        molstats.deltaJ = 0.3420/1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = '2-amino-1-propanol conf 2';
        
    case 42
        molstats.a = 9769.63045/1000;
        molstats.b = 868.845880/1000;
        molstats.c = 818.518770/1000;
        
        molstats.DK = 24.193/1000;
        molstats.DJK = -0.8843/1000;
        molstats.DJ = 0.04627/1000;
        molstats.deltaK = -0.034/1000;
        molstats.deltaJ = 0.3420/1000;
        
        molstats.mua = 1.274;
        molstats.mub = 2.288;
        molstats.muc = 1;
        molstats.molname = 'hexanal conf 1';
        
    case 43
        molstats.a = 5399.89397/1000;
        molstats.b = 1143.248678/1000;
        molstats.c = 1028.990827/1000;
        
        molstats.DK = 14.5675/1000;
        molstats.DJK = -1.64943/1000;
        molstats.DJ = 0.30363/1000;
        molstats.deltaK = 1.2275/1000;
        molstats.deltaJ = 0.064466/1000;
        
        molstats.mua = 0.515;
        molstats.mub = 2.292;
        molstats.muc = 1.012;
        molstats.molname = 'hexanal conf 2';
        
    case 44
        molstats.a = 8975.4925/1000;
        molstats.b = 933.43862/1000;
        molstats.c = 898.08347/1000;
        
        molstats.DK = 72.48/1e6;
        molstats.DJK = -2.5930/1e6;
        molstats.DJ = 0.09094/1e6;
        molstats.deltaK = -3.005/1e6;
        molstats.deltaJ = -0.00256/1e6;
        
        molstats.mua = 1.918;
        molstats.mub = 1.651;
        molstats.muc = 0.877;
        molstats.molname = 'hexanal conf 3';
        
    case 45
        molstats.a = 5995.20639/1000;
        molstats.b = 1046.73937/1000;
        molstats.c = 945.97194/1000;
        
        molstats.DK = 18.060/1000;
        molstats.DJK = -2.0086/1000;
        molstats.DJ = 0.19870/1000;
        molstats.deltaK = 1.996/1000;
        molstats.deltaJ = 0.049058/1000;
        
        molstats.mua = 0.983;
        molstats.mub = 2.370;
        molstats.muc = 0.715;
        molstats.molname = 'hexanal conf 4';
        
    case 46
       molstats.a = 6116.50288/1000;
        molstats.b = 1167.30037/1000;
        molstats.c = 1059.54145/1000;
        
        molstats.DK = 17.889/1000;
        molstats.DJK = -2.5335/1000;
        molstats.DJ = 0.28619/1000;
        molstats.deltaK = 0.772/1000;
        molstats.deltaJ = 0.03319/1000;
        
        molstats.mua = 0.0461;
        molstats.mub = 2.251;
        molstats.muc = 0.833;
        molstats.molname = 'hexanal conf 5';  
        
    case 47
        molstats.a = 4667.6175/1000;
        molstats.b = 1336.76933/1000;
        molstats.c = 1166.12535/1000;
        
        molstats.DK = 20.716/1000;
        molstats.DJK = -5.4158/1000;
        molstats.DJ = 0.8711/1000;
        molstats.deltaK = 3.324/1000;
        molstats.deltaJ = 0.25912/1000;
        
        molstats.mua = 0.581;
        molstats.mub = 2.469;
        molstats.muc = 0.19;
        molstats.molname = 'hexanal conf 6';  
        
    case 48
          molstats.a = 5455.60826/1000;
        molstats.b = 1055.75603/1000;
        molstats.c = 937.27598/1000;
        
        molstats.DK = 41.404/1000;
        molstats.DJK = -6.1640/1000;
        molstats.DJ = 0.50355/1000;
        molstats.deltaK = 2.323/1000;
        molstats.deltaJ = 0.118903/1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'hexanal conf 7'; 
        
    case 49
          molstats.a = 4827.91033/1000;
        molstats.b = 1240.84154/1000;
        molstats.c = 1159.91361/1000;
        
        molstats.DK = 40.213/1000;
        molstats.DJK = -9.3475/1000;
        molstats.DJ = 1.00661/1000;
        molstats.deltaK = 1.620/1000;
        molstats.deltaJ = 0.16839/1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'hexanal conf 8'; 
        
    case 50
           molstats.a = 12969.7951/1000;
        molstats.b = 775.68441/1000;
        molstats.c = 763.26201/1000;
        
        molstats.DK = 0/1000;
        molstats.DJK = -7.2775/1000;
        molstats.DJ = 0.07102/1000;
        molstats.deltaK = 1.620/1000;
        molstats.deltaJ = 0.16839/1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'hexanal conf 9'; 
        
    case 51
           molstats.a = 5461.5546/1000;
        molstats.b = 1149.07728/1000;
        molstats.c = 1102.89081/1000;
        
        molstats.DK = 37.03/1000;
        molstats.DJK = -4.2407/1000;
        molstats.DJ = 0.51927/1000;
        molstats.deltaK = 0/1000;
        molstats.deltaJ = 0.09360/1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'hexanal conf 10'; 
        
    case 52
           molstats.a = 3961.10569/1000;
        molstats.b = 1400.19125/1000;
        molstats.c = 1158.63001/1000;
        
        molstats.DK = 25.561/1000;
        molstats.DJK = -10.948/1000;
        molstats.DJ = 2.4272/1000;
        molstats.deltaK = 4.647/1000;
        molstats.deltaJ = 0.70955/1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'hexanal conf 11'; 
        
    case 53
            molstats.a = 5439.6534/1000;
        molstats.b = 1098.76209/1000;
        molstats.c = 1050.33986/1000;
        
        molstats.DK = 0/1000;
        molstats.DJK = -8.88272/1000;
        molstats.DJ = 0.6234/1000;
        molstats.deltaK = 0/1000;
        molstats.deltaJ = 0.1283/1000;
        
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'hexanal conf 12'; 
    case 54
        molstats.a = 34891.731/1000;
        molstats.b = 9350.653/1000;
        molstats.c = 8135.216/1000;
        
%         molstats.DK = 0/1000;
%         molstats.DJK = -8.88272/1000;
%         molstats.DJ = 0.6234/1000;
%         molstats.deltaK = 0/1000;
%         molstats.deltaJ = 0.1283/1000;
%         
        molstats.mua = .046;
        molstats.mub = 1.438;
        molstats.muc = 0;
        molstats.molname = 'ethanol'; 
    case 55
        molstats.a = 30209.040/1000;
        molstats.b = 9239.112/1000;
        molstats.c = 7930.497/1000;
        
%         molstats.DK = 0/1000;
%         molstats.DJK = -8.88272/1000;
%         molstats.DJ = 0.6234/1000;
%         molstats.deltaK = 0/1000;
%         molstats.deltaJ = 0.1283/1000;
%         
        molstats.mua = .067;
        molstats.mub = 1.519;
        molstats.muc = .083;
        molstats.molname = 'Chiral D-ethanol'; 
     case 'benzonitrile'
%         A (MHz) 5655.2654 (72)
% B (MHz) 1546.875864 (66)
% C (MHz) 1214.40399 (10)
        molstats.a = 5655.2654/1000;
        molstats.b = 1546.875864/1000;
        molstats.c = 1214.40399/1000;
        molstats.mua = 1;
        molstats.mub = 0;
        molstats.muc = 0;
        molstats.molname = 'Benzonitrile';
      
      case 'benzonitrile2'
%         A (MHz) 5655.2654 (72)
% B (MHz) 1546.875864 (66)
% C (MHz) 1214.40399 (10)
        molstats.a = 4655.2654/1000;
        molstats.b = 1546.875864/1000;
        molstats.c = 1214.40399/1000;
        molstats.mua = 1;
        molstats.mub = 0;
        molstats.muc = 0;
        molstats.molname = 'Benzonitrile';
        
     case 57
         % A = 1347.7899(12) MHz, B = 1006.02030(94) MHz, C = 719.81749(24) MHz.
        molstats.a = 1347.7899/1000; % in GHz
        molstats.b = 1006.02030/1000;
        molstats.c = 719.81749/1000;
        
%         molstats.DK = 0/1000; % in MHz
%         molstats.DJK = -8.88272/1000;
%         molstats.DJ = 0.6234/1000;
%         molstats.deltaK = 0/1000;
%         molstats.deltaJ = 0.1283/1000;
%         
        molstats.mua = 1;
        molstats.mub = 1;
        molstats.muc = 1;
        molstats.molname = 'Argon-Benzonitrile';  
     case 58
        molstats.a = 800;
        molstats.b = 10.5;
        molstats.c = 10.5;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 0;
        molstats.muc = 0;  
        molstats.molname = 'Diatomic CaF avbout';
    case 59
        molstats.a = 15272.17/1000;
        molstats.b = 1161.46/1000;
        molstats.c = 1119.93 / 1000;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = '1pent_guess';
    case 'isoprene'
        molstats.a = q * 15272.17/1000;
        molstats.b = 1161.46/1000;
        molstats.c = 1119.93 / 1000;  
        
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
        molstats.molname = '1pent_guess';
    otherwise
        molstats = 0;
end
if isstruct(molstats)
    molstats.molid = molid;
    molstats.theory = 1;
    if molstats.a < 50
        molstats.a = molstats.a * 1000;
        molstats.b = molstats.b * 1000;
        molstats.c = molstats.c * 1000;  
        if isfield(molstats,'DK')
            molstats.DK = molstats.DK * 1000;
            molstats.DJK = molstats.DJK * 1000;
            molstats.DJ = molstats.DJ * 1000;
            molstats.deltaK = molstats.deltaK * 1000;
            molstats.deltaJ = molstats.deltaJ * 1000;
        end
    end
    if isfield(molstats,'mua') == 0
        molstats.mua = 1;  %from melanie's paper
        molstats.mub = 1;
        molstats.muc = 1;  
    end
    if isfield(molstats,'molname') == 0
        molstats.molname = molid;
    end
    molstats = updatemolstats(molstats);
end


