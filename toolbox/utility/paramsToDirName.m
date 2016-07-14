function conditionDir = paramsToDirName(gaborParams,temporalParams,oiParams,mosaicParams,rgcParams)

theGaborName = sprintf('cpd%0.0f_sfv%0.2f_fw%0.3f',...
    gaborParams.cyclesPerDegree,...
    gaborParams.fieldOfViewDegs,...
    gaborParams.gaussianFWHMDegs);

if (~isfield(temporalParams,'eyesDoNotMove'))
    temporalParams.eyesDoNotMove = true;
end
theTemporalName = sprintf('tau%0.3f_dur%0.2f_em%0.0f',...
    temporalParams.windowTauInSeconds, ...
    temporalParams.stimulusDurationInSeconds, ...
    ~temporalParams.eyesDoNotMove);

theOIName = sprintf('b%0.0f_l%0.0f', ...
    oiParams.blur, ...
    oiParams.lens);

theMosaicName = sprintf('LMS%0.2f_%0.2f_%0.2f_mfv%0.2f',...
    mosaicParams.LMSRatio(1),mosaicParams.LMSRatio(2),mosaicParams.LMSRatio(3), ...
    mosaicParams.fieldOfViewDegs);

conditionDir = [theGaborName '_' theTemporalName '_' theOIName '_' theMosaicName];
