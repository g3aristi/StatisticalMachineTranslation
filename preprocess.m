function outSentence = preprocess( inSentence, language )
%
%  preprocess
%
%  This function preprocesses the input text according to language-specific rules.
%  Specifically, we separate contractions according to the source language, convert
%  all tokens to lower-case, and separate end-of-sentence punctuation 
%
%  INPUTS:
%       inSentence     : (string) the original sentence to be processed 
%                                 (e.g., a line from the Hansard)
%       language       : (string) either 'e' (English) or 'f' (French) 
%                                 according to the language of inSentence
%
%  OUTPUT:
%       outSentence    : (string) the modified sentence
%
%  Template (c) 2011 Frank Rudzicz 

  global CSC401_A2_DEFNS
  
  % first, convert the input sentence to lower-case and add sentence marks 
  inSentence = [CSC401_A2_DEFNS.SENTSTART ' ' lower( inSentence ) ' ' CSC401_A2_DEFNS.SENTEND];

  % trim whitespaces down 
  inSentence = regexprep( inSentence, '\s+', ' '); 

  % initialize outSentence
  outSentence = inSentence;

  % perform language-agnostic changes
  % separate end of sentece puntuation
  outSentence = regexprep( outSentence, '[.!?](?= SENTEND)', ' $0');
  outSentence = regexprep(outSentence, '\.\.+', ' $0 ');
  % separte other puntuation ,:;()[]{}"&$
  outSentence = regexprep( outSentence, '\,|\:|\;|\(|\)|\[|\]|\{|\}|\"|\&|\$', ' $0 ');
  % separte math operators %<>=+-/*^
  outSentence = regexprep( outSentence, '\%|\<|\>|\=|\+|\-|\/|\*|\^', ' $0 ');
  % separte diffrent types of quotations
  outSentence = regexprep( outSentence, '\`\`|''''', ' $0 ');
  % trim whitespaces
  outSentence = regexprep( outSentence, '\s+', ' ');

  switch language
   case 'e'
    % separating possessives and clitics 
    outSentence = regexprep( outSentence, 'n''t|''\w+', ' $0');
    % trim whitespaces
    outSentence = regexprep( outSentence, '\s+', ' ');
    

   case 'f'
    % separate french contractions
    % separate leading consonant and apostrophe from
    outSentence = regexprep( outSentence, '\w''(?=\w+)', '$0 ');
    % separate leading qu' from concatenated word
    outSentence = regexprep( outSentence, 'qu''\w+', '$0 ');
    % separate following on or il
    outSentence = regexprep( outSentence, '\w+''(?=on|il)', '$0 ');
    % should not be separated d?abord, d?accord, d?ailleurs, d?habitude
    outSentence = regexprep( outSentence, '(d'') (abord|accord|ailleurs|habitude)', '$1$2');
    % trim whitespaces
    outSentence = regexprep( outSentence, '\s+', ' ');

  end

  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );

