use array::ArrayTrait;
use debug::PrintTrait;

#[derive(Copy, Drop)]
struct User {
    username: felt252,
    address: felt252,
}

#[derive(Copy, Drop)]
struct Jobs {
    title: felt252,
    type: felt252,
    description: felt252,
    skills: felt252,
    compensation: felt252,
}

#[derive(Drop)]
struct Database {
    users: Array<User>,
    jobs: Array<Jobs>,
}

trait DatabaseTrait {
    fn createuser(ref self: Database, user: User);
    fn find_user(self: @Database, username: felt252) -> Array<u128>;
    fn createjob(ref self: Database, jobs: Jobs);
    fn find_job(self: @Database, title: felt252) -> Array<u128>;
}


impl DatabaseImpl of DatabaseTrait {
    fn createuser(ref self: Database, user: User) {
        self.users.append(user);
    }

    fn find_user(self: @Database, username: felt252) -> Array<u128> {
        let mut i = 0;
        let mut result = ArrayTrait::new();

        loop {
            let user: User = *self.users[i];
            if (user.username == username) {
                result.append(user);
                break;
            }
            i += 1;
        };
        result
    }
}
