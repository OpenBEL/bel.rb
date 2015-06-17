$TREE_DATA = [{
  "name": "STATEMENT",
  "parent": "null",
  "children": [
    {
      "name": "SUBJECT",
      "parent": "STATEMENT",
      "children": [
        {
          "name": "TERM",
          "parent": "SUBJECT",
          "children": [
            {
              "name": "fx(p)",
              "parent": "TERM"
            },
            {
              "name": "ARG",
              "parent": "TERM",
              "children": [
                {
                  "name": "NV",
                  "parent": "ARG",
                  "children": [
                    {
                      "name": "pfx(HGNC)",
                      "parent": "NV"
                    },
                    {
                      "name": "val(AKT1)",
                      "parent": "NV"
                    }
                  ]
                },
                {
                  "name": "ARG ",
                  "parent": "ARG",
                  "children": [
                    {
                      "name": "NULL",
                      "parent": "ARG"
                    },
                    {
                      "name": "NULL",
                      "parent": "ARG"
                    }
                  ]
                }
              ]
            }
          ]
        },
        {
          "name": "NULL",
          "parent": "SUBJECT"
        }
      ]
    },
    {
      "name": "OBJECT",
      "parent": "STATEMENT",
      "children": [
        {
          "name": "REL",
          "parent": "OBJECT",
          "children": [
            {
              "name": "rel(increases)",
              "parent": "REL"
            },
            {
              "name": "NULL",
              "parent": "REL"
            }
          ]
        },
        {
          "name": "TERM",
          "parent": "OBJECT",
          "children": [
            {
              "name": "fx(bp)",
              "parent": "TERM"
            },
            {
              "name": "ARG",
              "parent": "TERM",
              "children": [
                {
                  "name": "NV",
                  "parent": "ARG",
                  "children": [
                    {
                      "name": "pfx(MESHPP)",
                      "parent": "NV"
                    },
                    {
                      "name": "val(Apoptosis)",
                      "parent": "NV"
                    }
                  ]
                },
                {
                  "name": "ARG ",
                  "parent": "ARG",
                  "children": [
                    {
                      "name": "NULL",
                      "parent": "ARG"
                    },
                    {
                      "name": "NULL",
                      "parent": "ARG"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}];
