function QN_string = convertQNtostring(QN)
% converts a quantum number in int format to a string ready for SPFIT/SPCAT

QN_string = {};

for i = 1:length(QN)
    if QN(i) >= 100
        QN_string{i} = num2str(QN(i));
    elseif QN(i) >= 10
        QN_string{i} = [' ' num2str(QN(i))];
    else
        QN_string{i} = ['  ' num2str(QN(i))];
    end
end

if length(QN_string) == 1
    QN_string = QN_string{1};
end

end