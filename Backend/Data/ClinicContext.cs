using Microsoft.EntityFrameworkCore;
using ClinicBackend.Models;

namespace ClinicBackend.Data
{
    public class ClinicContext : DbContext
    {
        public ClinicContext(DbContextOptions<ClinicContext> options) : base(options) { }

        public DbSet<Patient> Patients => Set<Patient>();
    }
}