#include "dictionary.h"

    Dictionary::Dictionary(){
        
        
    }
    Dictionary::Dictionary(const Dictionary & d){
        set<string>::iterator it;
        for(it = d.words.begin();  it != d.words.end(); ++it){
            words.insert(*it);
        }
    }
    bool Dictionary::exist(const string & word) const{
        
        if(words.find(word) == words.end()){
            return true;
        }
        else 
            return false;
    }
    bool Dictionary::insert(const string & word){
        if (this->exist(word))
            return false;
        
        else{
            words.insert(word);
            return true;
        }
    }
    bool Dictionary::erase(const string & word){
               if (this->exist(word))
            return false;
        
        else{
            words.erase(word);
            return true;
        }
    }
    void Dictionary::clear(){
        words.clear();
    }
    bool Dictionary::empty()const{
        return words.empty();
    }
    int Dictionary::size()const{
        return words.size();
    }
    vector<string> Dictionary::wordsLenght(int l){
        set<string>::iterator it;
        vector <string> v; 
        for(it = words.begin(); it != words.end(); it++){
            if(it->size() == l){
                v.push_back(*it);
            }
        }
        return v;
    }
    int Dictionary::ocurrence(const char c){
        set<string>::iterator it;
        int cont = 0;
        for(it=words.begin(); it!=words.end(); ++it){
            if(it->find(c) != string::npos){
                cont ++;
            }
        }
        return cont;
    }
    void Dictionary::aniade(const Dictionary & dic){
        set<string>::iterator it = dic.words.begin();
        while(it!=dic.words.end()){
            this->words.insert(*it);
            it++;
        }
    }
    