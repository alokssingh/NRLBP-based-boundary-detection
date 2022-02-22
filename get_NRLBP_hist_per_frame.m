function LBP_hist = get_NRLBP_hist_per_frame(img,LUT,t)

LTP_map = generate_LBP_map(img,t);
imgSize = size(LTP_map);
LBP_hist = zeros(1,size(LUT,2));
for ii = 1:imgSize(1)
    for jj = 1:imgSize(2)
        LBP_hist = LBP_hist + LUT(LTP_map(ii,jj)+1,:);
    end
end



