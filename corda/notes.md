there are no global broadcast channels on Corda, so one must specify the recipients of each message

Corda nodes dicover each other via a Network Map service which publishes a list of peer nodes, containing metadata about who they are and what services they can offer

each nodes maintains a vault containing all of its known facts
the vault is a SQL db

**States**
states are immutable objects representing shared facts
once a state is created as a particular type, it cannot be changed to another type

Old states can be replaced with new ones. A new state is created by copying the old one and updating its properties as required. There is only one latest version at any point in time. Once a new state is created, the old one must be marked as historic.

Historic states remain accessible and provide a useful audit trail. States are never deleted.