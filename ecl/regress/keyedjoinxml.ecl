/*##############################################################################

    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
############################################################################## */

__set_debug_option__('targetClusterType', 'hthor');

mainRecord :=
        RECORD
integer8            sequence;
string20            forename;
string20            surname;
string20            alias;
unsigned8           filepos{virtual(fileposition)};
        END;

mainTableInline := dataset([{0,'','','',56},{5,'x','y','z',35}],mainRecord);
mainTableXml := dataset('~keyed.xml',mainRecord,xml);
mainTableCsv := dataset('~keyed.csv',mainRecord,csv);

sequenceKeyInline := INDEX(mainTableInline, { sequence, filepos }, 'sequencei.idx');
sequenceKeyCsv := INDEX(mainTableCsv, { sequence, filepos }, 'sequencec.idx');
sequenceKeyXml := INDEX(mainTableXml, { sequence, filepos }, 'sequencex.idx');


peopleRecord := RECORD
integer8        id;
string20        addr;
            END;

//peopleDataset := DATASET([{3000,'London'}], peopleRecord);
peopleDataset := DATASET([{3000,'London'},{3500,'Miami'},{30,'Houndslow'}], peopleRecord);


joinedRecord :=
        RECORD
integer8            sequence;
string20            forename;
string20            surname;
string20            addr;
unsigned8           filepos;
        END;

joinedRecord doJoin(peopleRecord l, mainRecord r) := TRANSFORM
    SELF := l;
    SELF := r;
    END;

output(join(peopleDataset, mainTableInline, left.id=right.sequence AND right.alias <> '',doJoin(left,right), KEYED(sequenceKeyInline), limit(100,count)));
output(join(peopleDataset, mainTableCsv, left.id=right.sequence AND right.alias <> '',doJoin(left,right), KEYED(sequenceKeyCsv), limit(100,count)));
output(join(peopleDataset, mainTableXml, left.id=right.sequence AND right.alias <> '',doJoin(left,right), KEYED(sequenceKeyXml), limit(100,count)));
