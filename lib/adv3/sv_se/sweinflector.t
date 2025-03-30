#charset "UTF-8"
#include <adv3.h>
#include <sv_se.h> 

class Inflector: object
    rules = nil
    exceptions = nil

    tag_pattern = nil
    construct(/*rules, exceptions*/) {
        tag_pattern = R'(%w+)<lsquare>(.*?)<rsquare>'; //= new RexPattern('a.*b');
        self.rules = new LookupTable();
        self.exceptions = new LookupTable();
    }

    inflect(word, genitive=nil) {
        local match = rexMatch(tag_pattern, word);
        //match = self.tag_pattern.match(word);
        if(match) {
            local baseWord = rexGroup(1)[3];
            local tags = rexGroup(2)[3];
            local tag_list = tags.split(',');
            //tadsSay('tags: <<tag_list>>\n');
            word = self.apply_tags(baseWord, tag_list, genitive);
            return word;
        }
        return word;
    }
;

class SwedishInflector: Inflector
    get_all_forms(word) {
        local match = rexMatch(tag_pattern, word);
        if(match) {
            local baseWord = rexGroup(1)[3];
            local tags = rexGroup(2)[3];
            tags = tags.split(',');

            local neutrum = tags.indexOf('nr') ? true: nil; 
            neutrum = tags.indexOf('ut') ? nil: true; 

            tadsSay(tags[1]);
            return [
                'indefinite_singular' ->  self._apply_singular_indefinite(baseWord, neutrum, nil),
                'definite_singular' ->  self._apply_singular_definite(baseWord, neutrum, nil),
                'indefinite_plural' ->  self._apply_plural_indefinite(baseWord, neutrum, nil),
                'definite_plural' ->  self._apply_plural_definite(baseWord, neutrum, nil)
            ];
        }

        return [
          'indefinite_singular' ->  nil,
          'definite_singular' ->  nil,
          'indefinite_plural' ->  nil,
          'definite_plural' ->  nil
        ];
    }

    get_relative_pronoun(item) {
        if (item.isPlural) {
            return !item.isUter ? 'vilket' : 'vilken';
        } 
        return !item.isUter ? 'vilkas' : 'vilka';
    }

    apply_tags(word, tags, genitive) {
      
        local neutrum = tags.indexOf('nr') ? true: nil; // true if 'nr' in tags else nil;  // Neutrum/Utrum
        neutrum = tags.indexOf('ut') ? nil: true; // nil if 'ut' in tags else true;  // Utrum/Neutrum
        local singular = tags.indexOf('s'); //'s' in tags;
        local plural = tags.indexOf('p');
        local indefinite = tags.indexOf('ub');
        local definite =  tags.indexOf('b');

        if (singular && indefinite) {
            return self._apply_singular_indefinite(word, neutrum, genitive);
        }
        if (singular && definite) {
            return self._apply_singular_definite(word, neutrum, genitive);
        }
        if (plural && indefinite) {
            return self._apply_plural_indefinite(word, neutrum, genitive);
        }
        if (plural && definite) {
            return self._apply_plural_definite(word, neutrum, genitive);
        }
        return word;
    }

    _apply_singular_indefinite(word, neutrum, genitive) {
        local exception = self.exceptions[word];
        if(exception) {
          local inflected = exception['indefinite_singular'];
          if(inflected) {
              return inflected;
          }
        }
        return word;
    }

    _inner_apply_plural_indefinite(word, neutrum) {
        if(neutrum) {
            if(word.endsWith('e')) {
                return word + 'n';  // äpple -> äpplen
            }
            if(word.endsWith('et')) {
                return word;  // staket -> staket (plural obestämd)
            }
            return word + 'er';  // rum -> rummer
        }

        if(word.endsWith('a')) {
            return word + 'or';  // flicka -> flickor
        }
        if(word.endsWith('e')) {
            return word + 'ar';  // pojke -> pojkar
        }
        // TODO:
        //if(word[-1] in 'bdfghjlmnpqrstv') {
        //    return word + 'ar';  // katt -> katter
        //}
        return word + 'er';  // blomma -> blommor
    }

    _apply_singular_definite(word, neutrum, genitive) {
        local exception = self.exceptions[word];
        if(exception) {
          local inflected = exception['definite_singular'];
          if(inflected) {
              return inflected;
          }
        }

        if(neutrum) {
            return word + (word.endsWith('e') ? 't' : 'et');
        }
        return word + 'en';
        
    }

    _inner_apply_plural_definite(word, neutrum) {
        if(neutrum) {
            if(word.endsWith('et')) {
                return word + 'en';  // staket -> staketen
            }
            if(word.endsWith('e')) {
                return word + 'na';  // äpple -> äpplena
            }
            return word + 'erna';  // rum -> rummerna
        }
        if(word.endsWith('a')) {
            return word + 'orna';  // flicka -> flickorna
        }
        if(word.endsWith('e')) {
            return word + 'arna';  // pojke -> pojkarna
        }
        // TODO:
        // if(word[-1] in 'bdfghjlmnpqrstv') {
        //  return word + 'arna';  // katt -> katterna
        // }
        return word + 'erna';  // blomma -> blommorna
    }

    _apply_plural_indefinite(word, neutrum, genitive) {
        local exception = self.exceptions[word];
        if(exception) {
          local inflected = exception['indefinite_plural'];
          if(inflected) {
              return inflected;
          }
        }

        local inflected = self._inner_apply_plural_indefinite(word, neutrum);
        return inflected;
    }

    _apply_plural_definite(word, neutrum, genitive) {
        local exception = self.exceptions[word];
        if(exception) {
          local inflected = exception['definite_plural'];
          if(inflected) {
              return inflected;
          }
        }

        local inflected = self._inner_apply_plural_definite(word, neutrum);
        return inflected;
    }
;