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
    jobtype: JobType,
    description: felt252,
    skills: felt252,
    compensation: felt252,
}

#[derive(Copy, Drop)]
enum JobType {
    FullTime: (),
    Contract: (),
    Gig: (),
}

#[derive(Drop)]
struct Database {
    users: Array<User>,
    jobs: Array<Jobs>,
}

impl JobTypePrintImpl of PrintTrait<JobType> {
    fn print(self: JobType) {
        match self {
            JobType::FullTime(_) => ('Full time').print(),
            JobType::Contract(_) => ('Contract').print(),
            JobType::Gig(_) => ('Gig').print(),
        }
    }
}

trait DatabaseTrait {
    fn createuser(ref self: Database, user: User);
    fn find_user(self: @Database, username: felt252);
    fn createjob(ref self: Database, jobs: Jobs);
    fn find_job(self: @Database, title: felt252);
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

    fn find_job(self: @Database, title: felt252) {
        let mut i = 0;

        loop {
            let jobs: Jobs = *self.jobs[i];
            if jobs.title == title {
                'Job found!'.print();
                jobs.title.print();
                jobs.jobtype.print();
                jobs.description.print();
                jobs.skills.print();
                jobs.compensation.print();
                break;
            }
            i += 1;
        };
    }
}

fn main() {
    let user = User {
        username: 'Best dev',
        address: '0x1234567891012345',
    };
    let user2 = User {
        username: 'dev',
        address: '0x1233567891012345',
    };

    let job1 = Jobs {
        title: 'Development',
        jobtype: JobType::Contract(()),
        description: 'A very great job to do',
        skills: 'Pyhton',
        compensation: '200USD',
    };

    let mut database = Database {
        users: ArrayTrait::new(),
        jobs: ArrayTrait::new(),
    };

    database.createuser(user);
    database.createuser(user2);
    database.createjob(job1);
    database.find_user('dev');
    database.find_job('Development');
    database.users.len().print();
}
