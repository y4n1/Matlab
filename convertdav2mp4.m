function convertdav2mp4(ffmpegBinPath, directoryName, csvFileName)
    % ffmpegBinPath = 'E:\ffmpeg\bin\'; -- location of ffmpeg.exe file
    % directoryName = 'E:\' 
    % csvFileName = 'test.csv';  % Name of csv file that contain all paths
    
    fid=fopen(csvFileName); % Reading the csv file
    tline = fgetl(fid);
    listPathName = cell(0,1);
    while ischar(tline) % Listdown all the pathNames that contain DAV files
        listPathName{end+1,1} = tline;
        tline = fgetl(fid);
    end
    fclose(fid);
    arrayCommand = {'commands'}
    % Write all the .dav files from all pathnames into a cell array
    for i = 1 : size(listPathName,1) 
        davDirectory = string(directoryName) + char(listPathName(i,1));
        % Read all DAV file in directory
        davFiles = dir(fullfile(davDirectory,'*.dav'));
        davCount = size(davFiles,1);
        for j=1:davCount
            fileNamed = davFiles(j:j).name
            disp(fileNamed);
            mp4Filename = string(davDirectory) + string(extractBetween(fileNamed,1,length(fileNamed) - 4));

            commandText = string(ffmpegBinPath) + 'ffmpeg.exe -y -i ' +  string(davDirectory) + string(fileNamed) + ...
                ' -vcodec libx264 -crf 24 -filter:v "setpts=1*PTS" '+ mp4Filename + '.mp4';
            arrayCommand = vertcat(arrayCommand, commandText);
        end    
    end
    % Write commands to be executed into cmd file 
    exeFile = fopen('convert_dav.cmd','wt');
    for f = 2:size(arrayCommand,1)
        fprintf(exeFile,'%s', arrayCommand(f));
        fprintf(exeFile, '\n' );
    end    
    fclose(exeFile);
    % execute the command
    system('convert_dav.cmd');
    disp('All files converted!!');
end    