# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Admission(models.Model):
    admission_id = models.AutoField(primary_key=True)
    patient = models.ForeignKey('Patient', models.DO_NOTHING)
    room = models.ForeignKey('Room', models.DO_NOTHING)
    admission_date = models.DateField()
    discharge_date = models.DateField(blank=True, null=True)
    status = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'admission'


class Appointment(models.Model):
    appointment_id = models.AutoField(primary_key=True)
    doctor = models.ForeignKey('Doctor', models.DO_NOTHING)
    appointment_date = models.DateField()
    appointment_time = models.TimeField()
    reason = models.CharField(max_length=255, blank=True, null=True)
    status = models.CharField(max_length=9, blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)
    def __str__(self):
        return f"Appointment with {self.doctor} on {self.appointment_date}"

    class Meta:
        managed = False
        db_table = 'appointment'
        


class ContactSupport(models.Model):
    ticket_id = models.AutoField(primary_key=True)
    user_sr_no = models.ForeignKey('Users', models.DO_NOTHING, db_column='user_sr_no')
    email = models.OneToOneField('Users', models.DO_NOTHING, related_name='contactsupport_email_set')
    phone_no = models.OneToOneField('Users', models.DO_NOTHING, db_column='phone_no', related_name='contactsupport_phone_no_set')
    subject = models.CharField(max_length=255)
    message = models.TextField()
    status = models.CharField(max_length=11, blank=True, null=True)
    support_agent = models.ForeignKey('Receptionist', models.DO_NOTHING, blank=True, null=True)
    response = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'contact_support'


class Doctor(models.Model):
    doctor_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    gender = models.CharField(max_length=6)
    education = models.CharField(max_length=100)
    specialization = models.CharField(max_length=100)
    phone_no = models.CharField(unique=True, max_length=10)
    email = models.CharField(unique=True, max_length=100)
    joining_date = models.DateField(blank=True, null=True)
    consultation_fee = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    time_slot_begin = models.TimeField()
    time_slot_end = models.TimeField()
    experience = models.IntegerField(blank=True, null=True)
    rating = models.DecimalField(max_digits=2, decimal_places=1, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'doctor'


class Documents(models.Model):
    patient = models.OneToOneField('Patient', models.DO_NOTHING, primary_key=True)  # The composite primary key (patient_id, appointment_id) found, that is not supported. The first column is selected.
    appointment = models.ForeignKey(Appointment, models.DO_NOTHING)
    prescription = models.TextField()
    lab_test_reports = models.TextField(blank=True, null=True)
    lab_bills = models.TextField(blank=True, null=True)
    final_bill = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'documents'
        unique_together = (('patient', 'appointment'),)


class FinalBills(models.Model):
    bill_id = models.IntegerField(primary_key=True)
    appointment = models.ForeignKey(Appointment, models.DO_NOTHING)
    patient = models.ForeignKey('Patient', models.DO_NOTHING)
    advance_paid = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    pending_amount = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    paid_amount = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    refund = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'final_bills'


class MedicinalPrescription(models.Model):
    prescription = models.OneToOneField('Prescriptions', models.DO_NOTHING, primary_key=True)
    medicine_name = models.TextField()
    dosage = models.TextField()
    remark = models.TextField(blank=True, null=True)
    date_of_prescription = models.DateField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'medicinal_prescription'


class Patient(models.Model):
    patient_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    gender = models.CharField(max_length=6)
    date_of_birth = models.DateField()
    phone_no = models.CharField(unique=True, max_length=10)
    email = models.CharField(max_length=100, blank=True, null=True)
    address = models.CharField(max_length=255, blank=True, null=True)
    blood_group = models.CharField(max_length=3, blank=True, null=True)
    emergency_contact_name = models.CharField(max_length=100, blank=True, null=True)
    emergency_contact_number = models.CharField(max_length=15, blank=True, null=True)
    registration_date = models.DateField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'patient'


class Payment(models.Model):
    payment_id = models.AutoField(primary_key=True)
    appointment = models.ForeignKey(Appointment, models.DO_NOTHING)
    patient = models.ForeignKey(Patient, models.DO_NOTHING)
    description = models.TextField()
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    billing_date = models.DateField(blank=True, null=True)
    payment_status = models.CharField(max_length=7, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'payment'


class PreSurgeryInfo(models.Model):
    prescription = models.OneToOneField('Prescriptions', models.DO_NOTHING, primary_key=True)
    surgery_type = models.TextField()
    suggested_date = models.DateField()
    suggested_time = models.CharField(max_length=50, blank=True, null=True)
    advice = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'pre_surgery_info'


class Prescriptions(models.Model):
    prescription_id = models.AutoField(primary_key=True)
    appointment = models.ForeignKey(Appointment, models.DO_NOTHING, blank=True, null=True)
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING, blank=True, null=True)
    patient = models.ForeignKey(Patient, models.DO_NOTHING, blank=True, null=True)
    prescription_date = models.DateField()
    symptoms = models.TextField()
    cause = models.TextField(blank=True, null=True)
    lab_tests = models.TextField(blank=True, null=True)
    hospitalization_needed = models.CharField(max_length=3, blank=True, null=True)
    type_of_hospitalization = models.CharField(max_length=12, blank=True, null=True)
    surgery_needed = models.CharField(max_length=3, blank=True, null=True)
    dietary_precautions = models.TextField(blank=True, null=True)
    remark_on_lab_test = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'prescriptions'


class Ratings(models.Model):
    patient = models.ForeignKey(Patient, models.DO_NOTHING)
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING)
    rating_value = models.IntegerField(blank=True, null=True)
    comment = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'rating'


class Receptionist(models.Model):
    receptionist_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    phone_no = models.CharField(unique=True, max_length=10)
    email = models.CharField(unique=True, max_length=100)
    hire_date = models.DateField(blank=True, null=True)
    shift = models.CharField(max_length=7, blank=True, null=True)
    salary = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'receptionist'


class Room(models.Model):
    room_id = models.AutoField(primary_key=True)
    room_number = models.CharField(max_length=10)
    room_type = models.CharField(max_length=12, blank=True, null=True)
    status = models.CharField(max_length=9, blank=True, null=True)
    daily_rate = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'room'


class Users(models.Model):
    user_sr_no = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=15, blank=True, null=True)
    last_name = models.CharField(max_length=15, blank=True, null=True)
    email_id = models.CharField(unique=True, max_length=50)
    phone_no = models.CharField(unique=True, max_length=10)
    password = models.CharField(max_length=255)
    gender = models.CharField(max_length=6,blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True,blank=True, null=True)
    role_as_a = models.CharField(max_length=12, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'users'
