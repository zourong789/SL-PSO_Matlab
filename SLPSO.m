%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Implementation of a social learning PSO (SL-PSO) for scalable optimization
%%
%%  See the details of SL-PSO in the following paper
%%  R. Cheng and Y. Jin, A Social Learning Particle Swarm Optimization Algorithm for Scalable Pptimization,
%%  Information Sicences, 2014
%%
%%  The source code SL-PSO is implemented by Ran Cheng 
%%
%%  If you have any questions about the code, please contact: 
%%  Ran Cheng at r.cheng@surrey.ac.uk 
%%  Prof. Yaochu Jin at yaochu.jin@surrey.ac.uk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%d: dimensionality
d = 30;
%maxfe: maximal number of fitness evaluations
maxfe = d*5000;
%runnum: the number of trial runs
runnum = 1;
%results: the best fitness values recorded from each run
results = zeros(13, runnum);

% 13 benchmark functions 
for funcid = 1 : 13
    n = d;
    switch funcid
         case 1

            % lu: define the upper and lower bounds of the variables
            lu = [-100 * ones(1, n); 100 * ones(1, n)];

        case 2

            lu = [-10 * ones(1, n); 10 * ones(1, n)];


        case 3

            lu = [-100 * ones(1, n); 100 * ones(1, n)];


        case 4

            lu = [-100 * ones(1, n); 100 * ones(1, n)];


        case 5

            lu = [-30* ones(1, n); 30 * ones(1, n)];



        case 6

            lu = [-100 * ones(1, n); 100 * ones(1, n)];


        case 7

            lu = [-1.28 * ones(1, n); 1.28 * ones(1, n)];


        case 8

            lu = [-500 * ones(1, n); 500 * ones(1, n)];


        case 9

            lu = [-5.12 * ones(1, n); 5.12 * ones(1, n)];


        case 10

            lu = [-32 * ones(1, n); 32 * ones(1, n)];


        case 11

            lu = [-600 * ones(1, n); 600 * ones(1, n)];


        case 12

            lu = [-50 * ones(1, n); 50 * ones(1, n)];


        case 13

            lu = [-50 * ones(1, n); 50 * ones(1, n)];


    end


% several runs
for run = 1 : runnum
    %parameter initiliaztion
    M = 100;
    m = M + floor(d/10);
    c3 = d/M*0.01;
    PL = zeros(m,1);

    for i = 1 : m
        PL(i) = (1 - (i - 1)/m)^log(sqrt(ceil(d/M)));
    end


    % initialization
    XRRmin = repmat(lu(1, :), m, 1);
    XRRmax = repmat(lu(2, :), m, 1);
    rand('seed', sum(100 * clock));
    p = XRRmin + (XRRmax - XRRmin) .* rand(m, d);
    fitness = yao_func(p, funcid); 
    v = zeros(m,d);
    bestever = 1e200;
    
    FES = m;
    gen = 0;
    ploti = 1;
    

    tic;
    % main loop
    while(FES < maxfe)


        % population sorting
        [fitness rank] = sort(fitness, 'descend');
        p = p(rank,:);
        v = v(rank,:);
        besty = fitness(m);
        bestp = p(m, :);
        bestever = min(besty, bestever);
        
        % center position
        center = ones(m,1)*mean(p);
        
        %random matrix 
        %rand('seed', sum(100 * clock));
        randco1 = rand(m, d);
        %rand('seed', sum(100 * clock));
        randco2 = rand(m, d);
        %rand('seed', sum(100 * clock));
        randco3 = rand(m, d);
        winidxmask = repmat([1:m]', [1 d]);
        winidx = winidxmask + ceil(rand(m, d).*(m - winidxmask));
        pwin = p;
        for j = 1:d
                pwin(:,j) = p(winidx(:,j),j);
        end
        
        % social learning
         lpmask = repmat(rand(m,1) < PL, [1 d]);
         lpmask(m,:) = 0;
         v1 =  1*(randco1.*v + randco2.*(pwin - p) + c3*randco3.*(center - p));
         p1 =  p + v1;   
         
         
         v = lpmask.*v1 + (~lpmask).*v;         
         p = lpmask.*p1 + (~lpmask).*p;
         
         % boundary control
        for i = 1:m - 1
            p(i,:) = max(p(i,:), lu(1,:));
            p(i,:) = min(p(i,:), lu(2,:));
        end
        
        
        % fitness evaluation
        fitness(1:m - 1,:) = yao_func(p(1:m - 1,:), funcid);
        fprintf('Best fitness: %e\n', bestever); 
        FES = FES + m - 1;

        gen = gen + 1;
    end;
    fprintf('Run No.%d Done!\n', run); 
    disp(['CPU time: ',num2str(toc)]);
    results(funcid, run) = bestever;
end;


end;

    

