% strline='#  553  华东.宁华5916线  500  0  5.088000  69.286995  6.213150e-04  福建.宁德.500.820  福建.金华.500.2380  442.704  72.208  -439.056  -55.970  0  0  2500.000  453.76  92.11  -439.17  0.00  10737  12964  820  2380  0  0  0.001846  0.025138  1.712500  0.000000';
% strnode1='#  639  福建.宁德/500kV.Ⅰ段母线  500  福建.宁德.500.820  531.828  -10.807  0  527.161  ''  582  820  0';
% strnode2='#  1868  福建.金华/500kV.Ⅰ段母线  500  福建.金华.500.2380  519.946  -17.088  0  517.533  ''  1760  2380  0';
% strnode3='# 86 福建.宁德/500kV.宁华5916线高抗  500   -180.000   525.000  华东.宁华5916线  福建.宁德.500.820  0.000   -165.366  0   -165.33  10738  820  0';

strline='#  553  华东.宁华5916线  500  0  5.088000  69.286995  6.213150e-04  福建.宁德.500.820   福建.金华.500.2380    618.268     96.759   -611.071    -25.415  0  0   2500.000    640.49    107.07   -613.86     25.61  10737  12964  820  2380  0  0  0.001846  0.025138  1.712500  0.000000';
strnode1='#  639  福建.宁德/500kV.Ⅰ段母线  500  福建.宁德.500.820   527.169     3.840  0   527.304  ''  582  820  0';
strnode2='# 1868  福建.金华/500kV.Ⅰ段母线  500  福建.金华.500.2380   513.831    -5.146  0   516.879  ''  1760  2380  0';


% strline='#  259  福建.中浦线  220  0  1.171200  10.902200  5.993951e-05  福建.洋中.220.1701  福建.浦口.220.858  57.054  14.946  -56.975  -20.610  0  0  583.000  56.85  13.94  -56.85  -16.48  11178  10764  1701  858  0  0  0.002214  0.020609  0.031708  700.000000';
% strnode1='#  977  福建.洋中/220kV.Ⅰ段母线  220  福建.洋中.220.1701  231.508  -15.007  0  230.076  ''  893  1701  0';
% strnode2='#  670  福建.浦口/220kV.Ⅰ段母线  220  福建.浦口.220.858  230.379  -15.652  0  229.033  ''  610  858  0';

expline = regexp(strline, '\s+', 'split');
expnode1 = regexp(strnode1, '\s+', 'split');
expnode2 = regexp(strnode2, '\s+', 'split');

U1 = str2num(expnode1{6})*exp(str2num(expnode1{7})/180*pi*1i);
U2 = str2num(expnode2{6})*exp(str2num(expnode2{7})/180*pi*1i);

R = str2num(expline{6});
X = str2num(expline{7});
B = str2num(expline{8})*2;
Z = R + X*1i;
S12 = U1*conj((U1-U2)/Z)-abs(U1)^2*B/2*1i+165.366*1i;