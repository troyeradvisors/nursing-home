using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RepoInfrastructure.Concrete;
using System.Data.Objects.DataClasses;
using System.Data.Objects;
using System.Data;
namespace NursingHome.Domain
{
    public class Repository<T> : ContextRepository<T, HomeEntities> where T : EntityObject
    {
        public Repository(bool enableLazyLoading = true) : base(enableLazyLoading){}
    }
    public class ReadRepository<T> : ContextReadonlyRepository<T, HomeEntities> where T : EntityObject
    { 
        public ReadRepository(bool enableLazyLoading = true) : base(enableLazyLoading){}
    }
}
