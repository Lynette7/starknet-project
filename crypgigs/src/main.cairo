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
    jobtype: felt252,
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
    fn find_user(self: @Database, username: felt252);
    fn createjob(ref self: Database, jobs: Jobs);
    //fn find_job(self: @Database, title: felt252) -> Array<u128>;
}

impl DatabaseImpl of DatabaseTrait {
    fn createuser(ref self: Database, user: User) {
        self.users.append(user);
    }

    fn find_user(self: @Database, username: felt252) {
    let mut i = 0;

    loop {
        let user: User = *self.users[i];
        if user.username == username {
            'User found!'.print();
            user.username.print();
            user.address.print();
            break;
        }
        i += 1;
    };
    }

    fn createjob(ref self: Database, jobs: Jobs) {
        self.jobs.append(jobs);
    }
}

fn main() {
    let user = User {
        username: 'Bestdev',
        address: '0x1234567891012345',
    };

    let job1 = Jobs {
        title: 'Development',
        jobtype: 'contract',
        description: 'A very great job to do',
        skills: 'Pyhton',
        compensation: '200USD',
    };

    let mut database = Database {
        users: ArrayTrait::new(),
        jobs: ArrayTrait::new(),
    };

    database.createuser(user);
    database.createjob(job1);
    database.find_user('Bestdev');
    database.users.len().print();
}
