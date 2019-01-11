Data=load('VI16um215G.mat');
Freq=215e9;
Load=2;	%Options are 1, 2 and 3. Take T embedding as an example, 1 ccoresponds to load in series with gate.
Embed='T';	%Options are "T" and "Pi"
[VS1max,VL1max,PL1max,valueMax,powerMax]=osc_embed_sweep(Freq,Load,Embed,Data.VI16um215G);
fprintf('The VS1 at maximum power is %g.\n',VS1max);
fprintf('The VL1 at maximum power is %g.\n',VL1max);
fprintf('The PL1 at maximum power is %g.\n',PL1max);
fprintf('The embedding network at maximum power is: R=%g, Embed1=%g, Embed2=%g, Embed3=%g .\n',valueMax);
fprintf('The maximum power is %g.\n',powerMax);