function errors = train_all_fis(training_data, test_data)
    opt_methods = [0,1];
    clustering_methods = ["GridPartition", "SubtractiveClustering", "FCMClustering"];
    train_input = training_data(:, 1:end-1);
    train_output = training_data(:, end);
    test_input = training_data(:, 1:end-1);
    test_output = training_data(:, end);
    for i = 1:3
        clustering_method = clustering_methods(i);
        genOptions = genfisOptions(clustering_method);
        fis = genfis(train_input, train_output,genOptions);
        for j = 0:1
            anOptions = anfisOptions("InitialFis", fis, "ValidationData", test_data, "OptimizationMethod", j);
            trained_fis = anfis(training_data, anOptions);
            str_file = "fis/"+clustering_method+"_"+j;
            writeFIS(trained_fis, str_file);
            result = evalfis(trained_fis,test_input);
            mse = sum((result - test_output).^2)/numel(result);
            fprintf("Clustering method: %s; opt method: %d, mse: %d", clustering_method, j, mse);
        end
    end
end