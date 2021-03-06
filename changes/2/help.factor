USING: accessors arrays assocs classes combinators generic
help.markup help.topics kernel make namespaces prettyprint
regexp sequences splitting words words.symbol ;
IN: help

: remove-<> ( str -- str )
    ">" "" replace
    "<" "" replace ;

: skov-name ( str -- str )
    R/ .{2,}-.{2,}/ [ "-" " " replace ] re-replace-with
    R/ .+>>/ [ remove-<> " (accessor)" append ] re-replace-with
    R/ >>.+/ [ remove-<> " (mutator)" append ] re-replace-with
    R/ <.+>/ [ remove-<> " (constructor)" append ] re-replace-with
    R/ >.+</ [ remove-<> " (destructor)" append ] re-replace-with ;

M: word article-name name>> skov-name ;

M: word article-title
    dup [ parsing-word? ] [ symbol? ] bi or [ name>> ] [ unparse ] if skov-name ;

<PRIVATE

: (word-help) ( word -- element )
    [
        {
            [ \ $vocabulary swap 2array , ]
            [ \ $graph swap 2array , ]
            [ word-help % ]
            [ \ $related swap 2array , ]
            [ dup global at [ get-global \ $value swap 2array , ] [ drop ] if ]
        } cleave
    ] { } make ;

PRIVATE>

M: generic article-content (word-help) ;

M: class article-content (word-help) ;
