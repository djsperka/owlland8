function check_filters_plot
global cal RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus right_fig left_fig menu_fig;

    
    N=cal.collect;
    screen=get(0,'screensize');
    figure('position',[500 400 screen(3)/1.7 screen(4)/2],...
    'color', cal.c_yellow,'tag','check_filters_plot');
    subplot(2,2,1);hold on;
    axis([0 12000 -100 -20]);
    ylabel('Abs. Magnitude dB'); grid on;
    title(['RIGHT & LEFT TRX FUNCTIONS']);
    
        
    subplot(2,2,3); hold on;
    axis([0 12000 -190 190]);
    ylabel('Phase [Degrees]'); grid on;
    xlabel('Frequency [Hertz]');

    y=abs(cal.trx_L(1:end-1));  
    subplot(2,2,1);hold on;
    plot(cal.freq_scale(1:N/2),20*log10(y),'r');
    subplot(2,2,3); hold on;
    plot(cal.freq_scale(1:N/2),angle(cal.trx_L(1:end-1))*180/pi,'r');
       
    y=abs(cal.trx_R(1:end-1));
    subplot(2,2,1);hold on;
    plot(cal.freq_scale(1:N/2),20*log10(y),'b');
    legend('Left trx', 'Right trx')
    subplot(2,2,3); hold on;
    plot(cal.freq_scale(1:N/2),angle(cal.trx_R(1:end-1))*180/pi,'b');

    
    subplot(2,2,2);hold on;
    title(['DIFFERENCE TRX FUNCTION']);

    axis([0 12000 -20 20]);
    ylabel('Difference dB'); grid on;
        
    subplot(2,2,4); hold on;
    axis([0 12000 -190 190]);
    ylabel('Difference [Degrees]'); grid on;
    xlabel('Frequency [Hertz]');

    y_L=abs(cal.trx_L(1:end-1));  
    y_R=abs(cal.trx_R(1:end-1));

    subplot(2,2,2);hold on;
    plot(cal.freq_scale(1:N/2),20*log10(y_R)-20*log10(y_L),'k.');

    subplot(2,2,4);hold on;
    plot(cal.freq_scale(1:N/2),(angle(cal.trx_R(1:end-1))-angle(cal.trx_L(1:end-1)))*180/pi,'k.');
