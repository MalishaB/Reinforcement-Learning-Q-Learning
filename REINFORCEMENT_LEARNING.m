clear all
clc
% ***************************************** With Reinforcement learning  ********************************** 
R_Matrix = csvread('RMatrix.csv')
R=R_Matrix';        % create a random matrix 
epsilon = 0.0159;       % probability of choosing a state  
gamma=0.80;            % learning parameter
q=zeros(size(R));      % initialize Q as zero      % immediate reward matrix; 
q1=ones(size(R))*inf;  % initialize previous Q as big number
count=0;              % counter  
Action_random=0;
Action_greedy=0;
    for episode_QL=0:1
        % random initial state
            y=randperm(size(R,1));
            state=y(1);
            present_State=state;
            
%%  select  action from this state

% To choose by random method 
            rand_action=find(R(state,:)>0);      % find possible action of this state
% To choose by greedy method 
            uu=R(state,:);
            uu1=max(uu);
            cc=find(R(state,:)== uu1);
            greedy_action=cc ;

%% Choosing an action using Epsilon soft algo 
       
            Random_no=rand;
            if Random_no<epsilon        % Epsilon soft    
                if size(rand_action,1)>0
                  rand_Action=RandomPermutation(rand_action);  % randomize the possible action
                  if numel(rand_Action)==0                                  
                      continue
                  end
                  
                   Action=rand_Action(1);     % select an action 
%                    disp('Action is Random')
                   Action_random=Action_random+1;
                 end  
            else
                if size(greedy_action,1)>0
                   greedy_Action=RandomPermutation(greedy_action);   % greedy possible action
                        if numel(greedy_action)==0                                  
                              continue
                        end
                   Action=greedy_Action(1) ;     % select an action 
%                    disp('Action is Greedy')
                   Action_greedy=Action_greedy+1;
               end 
            end 
       
            qMax=max(q,[],1);

            gamma=0.80;
            learn_rate=0.9;
            q(state,Action)=   q(state,Action)*(1-learn_rate) +  learn_rate*(R(state,Action)+gamma*(qMax(Action)));
            
           action=Action;
           Old_state=state;
           Action_Taken=Action;
       
       % break if convergence: small deviation on q for 1000 consecutive
            if sum(sum(abs(q1-q)))<0.0001 & sum(sum(q >0))
                  if count>1000,
        %              episode_QL        % report last episode
                     break          % for
                  else
                     count=count+1; % set counter if deviation of q is small
                  end
             else
              q1=q;
              count=0; % reset counter when deviation of q from previous q is large
       end
    end 

    %normalize q
    g=max(max(q));
    if g>0, 
       q=q/g;
    end
    disp('Reinforcement learning using Q-LEARNING')
    count;
    episode_QL ;    % report last episode
    
    Action_random
    Action_greedy
    
    new_q=q';      % back to the normal form 