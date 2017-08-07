% Trying something, resorting Ao and sorted_prop2.
% Don't use - use reorder instead - has options for sorting.

function[resortedAo,resortedprop] =  resort(sorted_evectors,sorted_prop2,...
    depth,sq_size);

for ii = 1:depth
    temp1 = sorted_evectors(:,2,ii);
    sorted_evectors(:,2,ii) = sorted_evectors(:,1,ii);
    sorted_evectors(:,1,ii) = temp1;
    
    temp3 = sorted_evectors(:,4,ii);
    sorted_evectors(:,4,ii) = sorted_evectors(:,3,ii);
    sorted_evectors(:,3,ii) = temp3;
    
    temp4 = sorted_prop2(4,4,ii);
    sorted_prop2(4,4,ii) = sorted_prop2(3,3,ii);
    sorted_prop2(3,3,ii) = temp4;
    
    temp2 = sorted_prop2(2,2,ii);
    sorted_prop2(2,2,ii) = sorted_prop2(1,1,ii);
    sorted_prop2(1,1,ii) = temp2;
end

resortedAo = sorted_evectors;
resortedprop = sorted_prop2;

