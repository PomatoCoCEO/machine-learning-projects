function net = lstm_network(P,T, numHiddenUnits)
    layers = [
        sequenceInputLayer(29),
        lstmLayer(numHiddenUnits, "OutputMode","last"),
        fullyConnectedLayer(4),
        softmaxLayer,
        classificationLayer
    ];

    options=trainingOptions ("sgdm","MaxEpochs",150, "Shuffle","never", "Verbose",true,"ExecutionEnvironment","gpu");
    net = trainNetwork(P, T, layers, options);
end