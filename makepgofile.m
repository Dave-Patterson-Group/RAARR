function makepgofile(molstats,pgofilename,temperature,types)
f = fopen(pgofilename,'w');
fprintf(f,'<?xml version="1.0"?>\n');

%for blah blah blahShowParts="True" UseUpper="True"
fprintf(f,'<Mixture Units="MHz" Version="Pgopher 7.1.108 13 Sep 2010 11:13" PlotUnits="MHz" ShowParts="False" UseUpper="False">\n');
if isfield(molstats,'forcemaxj') == 0
    molstats.forcemaxj = 64;
end
fprintf(f,'<Species Name="Species" Jmax="%d">\n',molstats.forcemaxj);
for (type = ['a' 'b' 'c'])
    
        fprintf(f,'<AsymmetricMolecule Name="Mol%c" Colour="Black" Jmin="0" Jmax="%d">\n',type,molstats.forcemaxj);
        fprintf(f,'<AsymmetricManifold Name="Ground" Initial="True">\n');
        fprintf(f,'<AsymmetricTop Name="v=0">\n');
        fprintf(f,'<Parameter Name="A" Value="%f"/>\n',molstats.a);
        fprintf(f,'<Parameter Name="B" Value="%f"/>\n',molstats.b);
        fprintf(f,'<Parameter Name="C" Value="%f"/>\n',molstats.c);
        fprintf(f,'<Parameter Name="DK" Value="%f"/>\n',molstats.DK);
        fprintf(f,'<Parameter Name="DJK" Value="%f"/>\n',molstats.DJK);
        fprintf(f,'<Parameter Name="DJ" Value="%f"/>\n',molstats.DJ);
        fprintf(f,'<Parameter Name="deltaK" Value="%f"/>\n',molstats.deltaK);
        fprintf(f,'<Parameter Name="deltaJ" Value="%f"/>\n',molstats.deltaJ);
        
        fprintf(f,'</AsymmetricTop>\n');
        fprintf(f,'</AsymmetricManifold>\n');
        if (type == 'a')
            fprintf(f,'<TransitionMoments Colour="Blue" Bra="Ground" Ket="Ground">\n');
        end
        if (type == 'b')
            fprintf(f,'<TransitionMoments Colour="Red" Bra="Ground" Ket="Ground">\n');
        end
        if (type == 'c')
            fprintf(f,'<TransitionMoments Colour="Lime" Bra="Ground" Ket="Ground">\n');
        end
        for (typeb = ['a' 'b' 'c']);
            if (typeb == type) && (ismember(type,types) == 1)
                if type == 'a'
                    strength = molstats.mua;
                end
                if type == 'b'
                    strength = molstats.mub;
                end
                if type == 'c'
                    strength = molstats.muc;
                end
            else
                strength = 0;
            end
            
            fprintf(f,'<CartesianTransitionMoment Axis="%c" Bra="v=0" Ket="v=0">\n',typeb);
            fprintf(f,'<Parameter Name="Strength" Value="%3.2f"/>\n',strength);
            fprintf(f,'</CartesianTransitionMoment>\n');
        end
        fprintf(f,'</TransitionMoments>\n');
        fprintf(f,'</AsymmetricMolecule>\n');
   
end
fprintf(f,'</Species>\n');
fprintf(f,'<Parameter Name="Temperature" Value="%3.2f"/>\n',temperature);
fprintf(f,'</Mixture>\n');

  fclose(f);  