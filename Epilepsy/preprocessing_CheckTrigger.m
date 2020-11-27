pt_trigger = []
trigger = []
for k = 1:length(pt1)
    if pt1(k,3) > 4
        pt_trigger(k,:) = pt1(k,1:3)     
    else
    end    
end


%% Only Trigger data 
% Check Trigger 
trigger = []
for k = 1:length(pt1)
    if pt1(k,3) > 4
        A = pt1(k,1:3)     
        trigger = vertcat(trigger, A)
    else
    end    
end


trigger2 = []
for k = 1:length(pt1)
    if pt1(k,3) > 0
        A = pt1(k,1:3)     
        trigger2 = vertcat(trigger, A)
    else
    end    
end
