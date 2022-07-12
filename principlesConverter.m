function [p_6, p_11] = principlesConverter

filenames = ["F:\THESIS\principles_L6.json" "F:\THESIS\nprinciples_L11.json"];

for file=1:2
    
    fid = fopen(filenames(file), 'r+');
    raw = fread(fid);
    fclose(fid);
    str = char(raw');
    json = jsondecode(str);
    principlemat = zeros(length(json), 4);
    
    for i=1:length(json)
        
        event_beg = int16(numberToSecs(json(i).("time")(1)));
        event_end = int16(numberToSecs(json(i).("time")(2)));
        
        principlemat(i, 1) = event_beg;
        principlemat(i, 2) = event_end;
        if(json(i).type{1, 1} == 's')
            principlemat(i, 3) = 1;
        end
%         principlemat(i, 4) = str2double(json(i).type{2, 1});
            
    end
    
    if(file == 1)
        p_6 = principlemat;
    elseif(file == 2)
        p_11 = principlemat;
    end
    
end

end




