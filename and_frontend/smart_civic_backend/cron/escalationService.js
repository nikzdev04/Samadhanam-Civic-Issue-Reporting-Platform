
const Complaint = require('../models/complaintModel');

const checkAndEscalateComplaints = async () => {
  console.log('Running escalation check at:', new Date().toLocaleTimeString());

  try {
    const now = new Date();

    const overdueComplaints = await Complaint.find({
      status: { $in: ['Pending', 'InProgress'] },
      targetDate: { $lt: now },
    });

    if (overdueComplaints.length === 0) {
      console.log('No complaints to escalate.');
      return;
    }

    console.log(`Found ${overdueComplaints.length} overdue complaints. Escalating...`);

    for (const complaint of overdueComplaints) {
      complaint.status = 'Escalated';
      complaint.timeline.push({
        status: 'Escalated',
        description: 'Complaint has passed the target resolution date and has been automatically escalated.',
        date: now,
      });
      await complaint.save();
      console.log(`Escalated complaint ID: ${complaint._id}`);
    }
  } catch (error) {
    console.error('Error during escalation check:', error);
  }
};

module.exports = { checkAndEscalateComplaints };
