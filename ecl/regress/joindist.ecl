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


namesRecord :=
            RECORD
string20        surname := '?????????????';
string10        forename := '?????????????';
string30        abc;
integer2        age := 25;
            END;

namesTable := dataset('x', namesRecord, THOR);

x := distribute(namesTable, HASH(surname,forename));

y := group(x, surname, forename,local);


ya1 := dedup(sort(y, abc), abc);
ya2 := table(ya1, {surname, forename, unsigned8 cnt := count(group)}, surname, forename, local);

yb1 := dedup(sort(y, age), age);
yb2 := table(yb1, {surname, forename, unsigned8 cnt := count(group)}, surname, forename, local);

JoinRecord :=
            RECORD
namesTable.surname;
namesTable.forename;
unsigned8       cnt_abc;
unsigned8       cnt_age;
            END;

JoinRecord JoinTransform (ya2 l, yb2 r) :=
                TRANSFORM
                    SELF.cnt_abc := l.cnt;
                    SELF.cnt_age := r.cnt;
                    SELF := l;
                END;

//This should be spotted as a join to self
Joined1 := join (ya2, yb2, LEFT.surname = RIGHT.surname AND LEFT.forename = RIGHT.forename, JoinTransform(LEFT, RIGHT), local) : persist('joined1');
Joined2 := sort(Joined1, forename, local);
output(Joined2,,'out.d00');

